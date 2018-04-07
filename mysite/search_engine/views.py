from django.shortcuts import render
from django.http import HttpResponse
import random
from urllib.request import *
import simplejson
import re 
# Create your views here.
def index(request):
	return render(request, 'search_engine/index.html')

def results(request):
	# try:

		raw_user_query = request.GET['searchInput']
		user_query = raw_user_query.replace(' ', '%20')

		# user_query = re.sub('[^A-Za-z0-9]', '+', raw_user_query)
		# if user_query.replace(' ', '') == '':
		# 	return render(request, 'search_engine/index.html')

		# serialized_indexer_response = simplejson.dumps([user_query])
		# return HttpResponse(serialized_indexer_response, content_type='application/json')


		package_details_needed = {
			'name'			   : 'Name',
			'collaborators_cnt': 'Collaborators',
			'fork_cnt'		   : 'Fork Count',
			'repo_description' : 'Description',
			'version_cnt'      : 'Version',
			'repo_url'		   : 'Repo URL',
			'last_update'	   : 'Last Updated',
			'owner'			   : 'Owned By',
			'license'		   : 'License',
			'homepage_url'	   : 'Homepage',
			'language'		   : 'Language',
			'star_cnt'		   : 'Starred in Github by',
			'size'			   : 'Size',



			'private'		   : 'Private'
		}

		package_table_order = [
			'Name',
			'Description',
			'Collaborators',
			'Fork Count',
			'Version',
			'Repo URL',
			'Last Updated',
			'Owned By',
			'License',
			'Homepage',
			'Language',
			'Starred in Github by',
			'Size'
		]

		filters = [
			'collaborators_cnt',
			# 'version_cnt',	
			# 'last_update',
			# 'star_cnt',
			# 'size',

			'license',
			'language'
			# 'size',


		]

		package_value_types = {}

		indexer_url = '35.230.82.124'
		''' breaks when it returns 0 results? 500 error: Child query must not match same docs with parent filter'''
		# query_string_base = 'http://' + indexer_url + ':8983/solr/nestedpackage/select?%20q={!parent%20which=%22path:1.git%22}body_markdown:'
		query_string_base = 'http://' + indexer_url + ':8983/solr/nestedpackage/select?q=name:'
		#need to have a proper query builder

		query = query_string_base + '*'#user_query

	

		query += '&facet=true'
		for key,_ in package_details_needed.items():
			query += '&facet.field=' + key


		query += '&rq={!ltr%20model=nestedpackage_model%20efi.text=' + user_query + '}&fl='
		# query += 'name,repo_description,score,[features]'

		for key,_ in package_details_needed.items():
			query += key + ','

		query += 'score'
		query += '&rows=10'

		# query += '[features]'
		# query = query[0:len(query)-1]

		# serialized_indexer_response = simplejson.dumps([query])
		# return HttpResponse(serialized_indexer_response, content_type='application/json')


		connection = urlopen(query)
		indexer_response = simplejson.load(connection);
		response = indexer_response['response']
	    # get the search input (so we can use it later)
		searchInput = request.GET.get('searchInput')

		raw_package_data = response['docs']
		raw_filter_data  = indexer_response['facet_counts']['facet_fields']
		num_packages     = response['numFound']

		raw_package_keys = []
		package_data     = {}
		table_data       = {}
		filter_data      = {}

		if len(raw_package_data) > 0:
			raw_package_keys = raw_package_data[0].keys();

		i=0
		for package in raw_package_data:
			short_package = {}
			for key, value in package.items():
				if key in package_details_needed.keys():
					short_package[package_details_needed[key]] = value[0]
			package_data[i] = short_package
			i+=1


		for i,package in package_data.items():
			for key, value in package.items():
				if key not in table_data.keys():
					table_data[key] = {}
				table_data[key][i] = value

		num_filter_options = 5;
		for filter_name in filters:
			raw_filter = raw_filter_data[filter_name]
			single_filter_data = []
			for i in range(0, min(len(raw_filter), num_filter_options*2), 2):
				option       = raw_filter[i]
				# serialized_indexer_response = simplejson.dumps(raw_filter[i+1])
				# return HttpResponse(serialized_indexer_response, content_type='application/json')
				num_packages = raw_filter[i+1]
				single_filter_data.append( (option, num_packages))

			new_index = package_details_needed[filter_name]
			filter_data[new_index] = single_filter_data

		# serialized_indexer_response = simplejson.dumps([response])
		# return HttpResponse(serialized_indexer_response, content_type='application/json')









		'''
		Get all stackoverflow pages related to these packages.
		'''

		indexer_url = '35.230.82.124'
		query_string_base = 'http://' + indexer_url + ':8983/solr/nestedpackage/select?q='
		#need to have a proper query builder

		query = query_string_base + user_query
		# query += '&rq={!ltr%20model=nestedpackage_model%20efi.text=' + user_query + '}' #&fl='
		# query += '&rows=10'
		query += '&fl=title_str,link'
		query += '&rows=20'


		connection = urlopen(query)
		stackoverflow_response = simplejson.load(connection);

		# serialized_indexer_response = simplejson.dumps([stackoverflow_response])
		# return HttpResponse(serialized_indexer_response, content_type='application/json')


		stackoverflow_response = stackoverflow_response['response']['docs']#[5]['link']
		for post in stackoverflow_response:
			if 'link' in post.keys():
				post['link'][0].replace('https://', 'https://www.')
			for key in post.keys():
				post[key] = post[key][0]




		return render(request, 'search_engine/results.html', {'package_data': package_data, 'table_data': table_data, 'filter_data': filter_data, 'user_query': raw_user_query, 'results': stackoverflow_response})

	# except:
		#make this a 404
		# return render(request, 'search_engine/results.html', {'indexer': indexer_response })



	# except:
	# 	indexer_packages = 'No_response'


	# #making up temp values for packages
	# packages = {}
	# for i in range(5):
	# 	package = {}
	# 	package['name'] = "my_name_{}".format(i)
	# 	package['rating'] = 5
	# 	package['response_time'] = "2hrs"
	# 	package['license'] = "MIT"
	# 	package['published'] = "2014-03-12"
	# 	package['last_modified'] = "2016-07-21"
	# 	package['num_contributor'] = "10"
	# 	package['size'] = "2MB"
	# 	package['dependencies'] = "None"
	# 	packages[i] = (package)

	# #format packages nicely for table
	# packages_for_table = {}
	# for key in package.keys():
	# 	packages_for_table[key] = {}
	# 	for package in packages.values():
	# 		package_name = package['name']
	# 		packages_for_table[key][package_name] = package[key]

	# #lets just say results look like this.
	# cicero_lorem_ipsum = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo."
	# results = []
	# for i in range(10):
	# 	result = {}
	# 	result['title'] = 'title'
	# 	result['url']   = 'www.reallylongurl.com'
	# 	result['desc']  = cicero_lorem_ipsum
	# 	results.append(result)

	# filters = []
	# for i in range(5):
	# 	fil = {}
	# 	fil['name'] = 'foobar'
	# 	fil['options'] = ['option 1', 'option 2', 'option 3', 'option 4', 'option 5']
	# 	filters.append(fil)

	# # selected_packages = [];
	# # for i in range(3):
	# # 	sp = {}
	# # 	sp['rating'] = random.random(1,10)/2
	# # 	sp['average_forum_response_time'] = random.random(1,10)
	# # 	sp['average_forum_response_time_type'] = 'minutes'
	# # 	sp['license'] = 'MIT'
	# # 	sp['documentation_quality'] = random.random(1,10)/2
	# # 	sp['last_modified'] = random.random(1,10)/2
	# # 	sp['published'] = "need to change this to date object"
	# # 	sp['num_contributor']

	# return render(request, 'search_engine/results.html', {'indexer': indexer_packages, 'indexer_packages_for_table': indexer_packages_for_table, 'results': results, 'packages': packages, 'filters': filters, 'packages_for_table': packages_for_table})


# def get_package_data(request):
	#ideally I'd like to send a get request to pull package data
# <!-- {% //include "path/to/file.html" %} -->


	# HttpResponse("""




	# 	<h2>hello world </h2>

	# 	<input name="query" type="text">
	# 	<button name="search-button"> search </button>




	# 	""")
