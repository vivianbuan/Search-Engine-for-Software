# DESIRED OUTPUT FORMAT (dummy data)
# 
# {
#   "mirror": "https://ftpmirror.gnu.org/a2ps/a2ps-4.14.tar.gz",
#   "sha256": "f3ae8d3d4564a41b6e2a21f237d2f2b104f48108591e8b83497500182a3ab3a4",
#   "name": "a2ps",
#   "url": "https://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz",
#   "desc": "Any-to-PostScript filter",
#   "homepage": "https://www.gnu.org/software/a2ps/",
#   "_childDocuments_": [
#     {
#       "url": "stackoverflowpackge1.html",
#       "title": "How to plot with python?",
#       "answer": "this package can does plot for python..."
#     },
#     {
#       "url": "stackoverflowpackge2.html",
#       "title": "Pychart?",
#       "answer": "blahblahblah"
#     }
#   ]
# }

# TO RUN THIS FILE
# python stackoverflow_extraction.py ./package_list_small.json ./so_json_small ./so_output/

import sys
import json
import os
import re
from bs4 import BeautifulSoup

def main():
	package_name_file = sys.argv[1]
	so_objects = sys.argv[2]
	output_folder = sys.argv[3]

	# Load the list of package names
	package_names = {}
	with open(package_name_file, 'r') as name_list:
		package_names = json.load(name_list)['packages']

	
	# Start building the result objects
	results = {}
	for package in package_names:
		results[package] = {}
		results[package]['name'] = package
		results[package]['_childDocuments_'] = []

		# tag = {}
		# tag['path'] = "stack" + package
		# results[package]['_childDocuments_'].append(tag)
		

	# Go over all the stackoverflow JSON object files
	for page in os.listdir(so_objects):

		with open(os.path.join(so_objects, page)) as json_file:
			source = {}
			source = json.load(json_file)

		# Parse the JSON object using BeautifulSoup
		with open(os.path.join(so_objects, page)) as file:
			soup = BeautifulSoup(file, "lxml")

			# Go over all the package names and see if it exists
			for package in package_names:
				if soup.find(string=re.compile(package)) is not None:
					current = {}
					current["link"] = source["link"]
					current["title"] = source["title"]
					current["tags"] = source["tags"]

					# current["_childDocuments_"] = source["answers"]

					answers = []
					for ans in source["answers"]:
						ans["path"] = "stack." + package + ".answer"
						answers.append(ans)
					current["_childDocuments_"] = answers

					current["up_vote_count"] = source["up_vote_count"]
					current["view_count"] = source["view_count"]
					current["answer_count"] = source["answer_count"]
					current["creation_date"] = source["creation_date"]
					current["last_edit_date"] = source["last_edit_date"]
					current["body_markdown"] = source["body_markdown"]
					current["code_snippet"] = source["code_snippet"]
					current["path"] = "stack." + package 
					results[package]["_childDocuments_"].append(current)


	# Write to output files, one package per file
	for res in results:
		with open(output_folder + str(res) + ".json", 'w') as outfile:
			json.dump(results[res], outfile)
		
		

	# Take out the outer package name
	# output = []
	# for res in results:
	# 	output.append(results[res])


	# Export the output
	# with open("output.json", 'w') as outfile:
	# 	json.dump(results, outfile)

if __name__ == "__main__":
	main()


















