from django.shortcuts import render
from django.http import HttpResponse

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
		package['name'] = "my_name"
		package['rating'] = 5
		package['response_time'] = "2hrs"
		package['license'] = "MIT"
		package['published'] = "2014-03-12"
		package['last_modified'] = "2016-07-21"
		package['num_contributor'] = "10"
		package['size'] = "2MB"
		package['dependencies'] = "None"
		packages.append(package)

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

	selected_packages = [];
	for i in range(3):
		sp = {}
		sp['average_forum_response_time'] = 2
		sp['average_forum_response_time_type'] = 'minutes'
		sp['license'] = 'MIT'
		sp['documentation_quality'] = 5
		# sp['']

	return render(request, 'search_engine/results_page.html', {'results': results, 'packages': packages, 'filters': filters, 'selected_packages': selected_packages})



# <!-- {% //include "path/to/file.html" %} -->


	# HttpResponse("""




	# 	<h2>hello world </h2>

	# 	<input name="query" type="text">
	# 	<button name="search-button"> search </button>




	# 	""")