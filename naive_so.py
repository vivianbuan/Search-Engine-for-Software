# INPUT:
# 1. A folder of HTML files, each of which is a Stackoverflow page
# 2. A JSON file that contains all packages we want to index over

# OUTPUT:
# JSON that
# 1. First maps package name
# 2. Other metadata from GitHub API for this package ?????
# 3. Additional metadata that we compute for the package
# 4. _childDocuments_ that contain list of related stackoverflow pages

# TO RUN THIS FILE
# python naive_so.py ./stackoverflow/test_packages.json ./stackoverflow/so_pages

import sys
import json
import os
import re
from bs4 import BeautifulSoup

def main():
	package_name_file = sys.argv[1]
	html_files = sys.argv[2]

	# Load the list of package names
	package_names = {}
	with open(package_name_file, 'r') as name_list:
		package_names = json.load(name_list)


	results = {}
	for package in package_names['packages']:
		results[package] = {}
		results[package]['name'] = package
		results[package]["_childDocuments_"] = []


	# Go over all the HTML files, looking for package names
	for page in os.listdir(html_files):

		# Parse html page using BeautifulSoup
		with open(os.path.join(html_files, page)) as f:
			soup = BeautifulSoup(f, "lxml")

			# Go over all the package names and see if exists
			for package in package_names['packages']:
				if (soup.find(string=re.compile(package)) is not None):
					results[package]["_childDocuments_"].append(page)


	# Take out the outer package name
	output = []
	for res in results:
		output.append(results[res])


	# Export the output
	with open("output.json", 'w') as outfile:
		json.dump(output, outfile)

if __name__ == "__main__":
	main()