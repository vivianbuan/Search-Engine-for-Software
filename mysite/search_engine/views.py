from django.shortcuts import render
from django.http import HttpResponse
import random

# Create your views here.
def index(request):
	return render(request, 'search_engine/index.html')

def results(request):
	# get the search input (so we can use it later)
	searchInput = request.GET.get('searchInput')

	#making up temp values for packages
	packages = []
	for i in range(5):
		package = {}
		package['name'] = "my_name_{}".format(i)
		package['rating'] = 5
		package['response_time'] = "2hrs"
		package['license'] = "MIT"
		package['published'] = "2014-03-12"
		package['last_modified'] = "2016-07-21"
		package['num_contributor'] = "10"
		package['size'] = "2MB"
		package['dependencies'] = "None"
		packages.append(package)

	#format packages nicely for table
	packages_for_table = {}
	for key in package.keys():
		packages_for_table[key] = {}
		for package in packages:
			package_name = package['name']
			packages_for_table[key][package_name] = package[key]

	#lets just say results look like this.
	cicero_lorem_ipsum = "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo."
	results = []
	for i in range(10):
		result = {}
		result['title'] = 'title'
		result['url']   = 'www.reallylongurl.com'
		result['desc']  = cicero_lorem_ipsum
		results.append(result)

	filters = []
	for i in range(5):
		fil = {}
		fil['name'] = 'foobar'
		fil['options'] = ['option 1', 'option 2', 'option 3', 'option 4', 'option 5']
		filters.append(fil)

	# selected_packages = [];
	# for i in range(3):
	# 	sp = {}
	# 	sp['rating'] = random.random(1,10)/2
	# 	sp['average_forum_response_time'] = random.random(1,10)
	# 	sp['average_forum_response_time_type'] = 'minutes'
	# 	sp['license'] = 'MIT'
	# 	sp['documentation_quality'] = random.random(1,10)/2
	# 	sp['last_modified'] = random.random(1,10)/2
	# 	sp['published'] = "need to change this to date object"
	# 	sp['num_contributor']

	return render(request, 'search_engine/results_page.html', {'results': results, 'packages': packages, 'filters': filters, 'packages_for_table': packages_for_table})


# def get_package_data(request):
	#ideally I'd like to send a get request to pull package data
# <!-- {% //include "path/to/file.html" %} -->


	# HttpResponse("""




	# 	<h2>hello world </h2>

	# 	<input name="query" type="text">
	# 	<button name="search-button"> search </button>




	# 	""")