"""
Python script to tag crawled HTML pages with the package names mentioned within the page. The script only
checks for mentions of package names in the content between tags.

Script requires 2 arguments, the file path to a JSON file that lists all packages to be checked against, 
and file path to directory of HTML pages to be tagged.

To run this script using the files in the test directory, run the command:
python tag_pages.py ./test/test_packages.json ./test/test_pages

and the output will be exported to a file name "tagged_output.json"
"""

import os
import re
import sys
import json
from bs4 import BeautifulSoup

def main():
	package_list_filepath = sys.argv[1]
	pages_dir = sys.argv[2]

	out_dict = {}
	package_dict = {}

	# Load the list of packages to tag pages with from JSON file
	with open(package_list_filepath, 'r') as list_f:
		package_dict = json.load(list_f)

	# Iterate over all pages in directory and tag them
	for page in os.listdir(pages_dir):
		cur_dict = {}

		# Parse html page using BeautifulSoup
		with open(os.path.join(pages_dir, page)) as f:
			soup = BeautifulSoup(f, "lxml")

			# Iterate through all packages and see if page mentions it
			for package in package_dict['packages']:
				cur_dict[package] = len(soup.find_all(name=True, string=re.compile(package)))

		# Update number of occurences of packages within each page
		out_dict[page] = cur_dict

	# Export information on pages into JSON file
	with open("tagged_output.json", 'w') as output_f:
		json.dump(out_dict, output_f)


if __name__ == "__main__":
	main()