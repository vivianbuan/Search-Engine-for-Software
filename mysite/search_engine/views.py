from django.shortcuts import render
from django.http import HttpResponse
import random
from urllib.request import *
import simplejson
import re 
from urllib.parse import urlparse
from collections import OrderedDict


'''
----------------- GLOBAL VARIABLES ------------------
'''

PACKAGE_DETAILS_NEEDED = {
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
	'readMe'		   : 'Readme',



	'private'		   : 'Private'
}

PACKAGE_TABLE_ORDER = [
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
	'Size',
	'Private',
	'Readme'
]

FILTERS = [
	# 'collaborators_cnt',
	# 'version_cnt',	
	# 'last_update',
	# 'star_cnt',
	# 'size',

	'license',
	'language'
	# 'size',
]

INDEXER_URL = '35.197.49.105'

# Create your views here.
def index(request):
	return render(request, 'search_engine/index.html')

def results(request):
	# try:

		raw_user_query = request.GET['searchInput']
		user_query = raw_user_query.replace(' ', '%20')
		user_query = urlparse(user_query).path

		searchInput = request.GET.get('searchInput')
		test = request.GET.get('test')
		if (not test):
			test = 0
		else:
			test = int(test)



		if (test > 0 and test <= 4):
			return get_package_response(INDEXER_URL, user_query, test=test)
		else:
			package_data, table_data, filter_data = get_package_response(INDEXER_URL, user_query, test=0)


		'''
		Get all stackoverflow pages related to these packages.
		'''
		if (test > 4 and test <= 5):
			return get_stackoverflow_response(INDEXER_URL, user_query, test=test)
		else:
			stackoverflow_response = get_stackoverflow_response(INDEXER_URL, user_query, test=test)

		if test == 6:
			# serialized_indexer_response = simplejson.dumps(
			# 	["Image Response", get_image(INDEXER_URL, "machine")])
			serialized_indexer_response = simplejson.dumps(["Image Response", get_image_list(INDEXER_URL, package_data)])
			return HttpResponse(serialized_indexer_response, content_type='application/json')
		else:
			image_data = get_image_list(INDEXER_URL, package_data)


		return render(request, 'search_engine/results.html', {'package_data': package_data, 'table_data': table_data, 'image_data': image_data, 'filter_data': filter_data, 'user_query': raw_user_query, 'results': stackoverflow_response})

	# except:
		#make this a 404
		# return render(request, 'search_engine/index.html')#, {'indexer': indexer_response })


def get_package_response(url, user_query, filter_results_by = [], test=0):

		'''
		Create the query
		'''
		query_string_base = 'http://' + url + ':8983/solr/nestedpackage/select?q=name:'
		query = query_string_base + user_query#'*'#user_query
		query += '&facet=true'
		for key,_ in PACKAGE_DETAILS_NEEDED.items():
			query += '&facet.field=' + key
		query += '&rq={!ltr%20model=nestedpackage_model%20efi.text="' + user_query + '"%20reRankDocs=100000}&fl='
		# query += 'name,repo_description,score,[features]'
		for key,_ in PACKAGE_DETAILS_NEEDED.items():
			query += key + ','
		query += 'score'
		query += '&rows=20'

		# query += '[features]'
		# query = query[0:len(query)-1]

		'''
		Test 1: Get the query
		'''
		if test == 1:
			serialized_indexer_response = simplejson.dumps(["Query for Package Info", query])
			return HttpResponse(serialized_indexer_response, content_type='application/json')

		connection = urlopen(query)
		indexer_response = simplejson.load(connection);
		response = indexer_response['response']
	    # get the search input (so we can use it later)

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
				if key in PACKAGE_DETAILS_NEEDED.keys():
					short_package[PACKAGE_DETAILS_NEEDED[key]] = value
					if key != 'language' and key != 'license':
						short_package[PACKAGE_DETAILS_NEEDED[key]] = short_package[PACKAGE_DETAILS_NEEDED[key]][0]
			package_data[i] = short_package
			i+=1


		for i,package in package_data.items():
			for key, value in package.items():
				if key not in table_data.keys():
					table_data[key] = {}
				table_data[key][i] = value

		num_filter_options = 5;
		for filter_name in FILTERS:
			raw_filter = raw_filter_data[filter_name]
			single_filter_data = []
			for i in range(0, min(len(raw_filter), num_filter_options*2), 2):
				option       = raw_filter[i]
				# serialized_indexer_response = simplejson.dumps(raw_filter[i+1])
				# return HttpResponse(serialized_indexer_response, content_type='application/json')
				num_packages = raw_filter[i+1]
				single_filter_data.append( (option, num_packages))

			new_index = PACKAGE_DETAILS_NEEDED[filter_name]
			filter_data[new_index] = single_filter_data

		'''
		Test 2: Get the package data
		'''
		if test == 2:
			serialized_indexer_response = simplejson.dumps(["Package Data", package_data])
			return HttpResponse(serialized_indexer_response, content_type='application/json')
		'''
		Test 3: Get the table_data
		'''
		if test == 3:
			serialized_indexer_response = simplejson.dumps(["Filter Data", table_data])
			return HttpResponse(serialized_indexer_response, content_type='application/json')
		'''
		Test 4: Get the package data
		'''
		if test == 4:
			serialized_indexer_response = simplejson.dumps(["Filter Data", filter_data])
			return HttpResponse(serialized_indexer_response, content_type='application/json')

		# temp = sorted(table_data.items(), key=lambda i:PACKAGE_TABLE_ORDER.index(i[0]))
		ordered_table = OrderedDict(sorted(table_data.items(), key=lambda i:PACKAGE_TABLE_ORDER.index(i[0])))
		return package_data, ordered_table, filter_data


def get_stackoverflow_response(url, user_query, filter_results_by = [], test=0):
		query_string_base = 'http://' + url + ':8983/solr/nestedpackage/select?fq={!parent%20which=%20path:2.stack}&q='
		#need to have a proper query builder
		query = query_string_base + user_query

		# query += '&rq={!ltr%20model=nestedpackage_model%20efi.text=' + user_query + '}' #&fl='
		# query += '&rows=10'
		query += '&fl=title_str,link'
		query += '&rows=40'
		query += '&hl=true&hl.fl=title,body_markdown'

		if test == 5:
			serialized_indexer_response = simplejson.dumps(["Query for Stackoverflow Response", query])
			return HttpResponse(serialized_indexer_response, content_type='application/json')

		connection = urlopen(query)
		response = simplejson.load(connection);


		posts_found = []
		stack_overflow_links = response['response']['docs']
		highlights = response['highlighting']

		deduped_response = []
		for post, hl_key in zip(stack_overflow_links, highlights.keys()):
			# post = stack_overflow_links[r_key]
			hl = highlights[hl_key]
			if 'link' in post.keys():
				post['link'].replace('https://', 'https://www.')
			for key in post.keys():
				if key != 'link':
					post[key] = post[key][0].replace('&#39;', "'").replace("&quot;", '"').replace("&amp;", "&")

			#replace post values with any highlights from Solr
			#also cap the length of the body text
			# if 'title' in hl.keys():
			# 	post['title'] = hl['title'][0]
			if 'body_markdown' in hl.keys():
				post['body_markdown'] = hl['body_markdown'][0].replace('\n', ' ').replace('\r', ' ')
			if 'body_markdown' not in post.keys():
				post['body_markdown'] = ''
			len_markdown = len(post['body_markdown'])
			post['body_markdown'] = post['body_markdown'][0:min(120, len_markdown)]


			# Perform Deduping
			if post['link'] not in posts_found:
				posts_found.append(post['link'])
				deduped_response.append(post)
			if len(deduped_response) == 15:
				break

		return deduped_response


def get_image(url, package_name):
	query = 'http://' + url + ':8983/solr/icons/select?q=name:' + package_name + "&rows=1"

	connection = urlopen(query)
	response = simplejson.load(connection)

	response = response['response']['docs']

	for post in response:
		if 'url' in post.keys():
			return post['url'][0]

	return ''


def get_image_list(url, package_data):
	imgs = [""] * len(package_data.items())

	for i, package in package_data.items():
		img = get_image(url, package['Name'])
		imgs[i] = img

	return imgs

def _ajax_reload_carousel(request):
	searchInput = request.GET.get('searchInput')
	filters = request.GET.get('filters')

	get_package_response(INDEXER_URL, user_query)
	return render(request, 'search_engine/templates/search_engine/_package_carousel_2.html', {filters})


		# user_query = re.sub('[^A-Za-z0-9]', '+', raw_user_query)
		# if user_query.replace(' ', '') == '':
		# 	return render(request, 'search_engine/index.html')

		# serialized_indexer_response = simplejson.dumps([user_query])
		# return HttpResponse(serialized_indexer_response, content_type='application/json')
