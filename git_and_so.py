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

# TO run with github stuff
# python git_and_so.py ./gh_json_dir ./so_json_small ./gh_output/

import sys
import json
import os
import re
from bs4 import BeautifulSoup

def main():
	# package_name_file = sys.argv[1]
	gh_objects = sys.argv[1]
	so_objects = sys.argv[2]
	output_folder = sys.argv[3]

	# Load the list of package names
	# package_names = {}
	# with open(package_name_file, 'r') as name_list:
	# 	package_names = json.load(name_list)['packages']

	
	# # Start building the result objects
	# results = {}
	# for package in package_names:
	# 	results[package] = {}
	# 	results[package]['name'] = package
	# 	results[package]['_childDocuments_'] = []

		# tag = {}
		# tag['path'] = "stack" + package
		# results[package]['_childDocuments_'].append(tag)


	results = {}
	count = 0
	for gh in os.listdir(gh_objects):
		# load a GitHub object and store in "present"
		with open(os.path.join(gh_objects, gh)) as js_file:
			present = {}
			present = json.load(js_file)

			curt_pkg_name = present['name']

			present["path"] = "1.git"
			present["id"] = str(present["github_id"])

			# results[curt_pkg_name] = present
			results[curt_pkg_name] = {}

			results[curt_pkg_name]["name"] = str(present["name"])
			results[curt_pkg_name]["owner"] = str(present["owner"])
			results[curt_pkg_name]["created_time"] = str(present["created_time"])
			results[curt_pkg_name]["pm_description"] = str(present["pm_description"])
			results[curt_pkg_name]["pm_name"] = str(present["pm_name"])
			results[curt_pkg_name]["pm_dependency_cnt"] = str(present["pm_dependency_cnt"])
			results[curt_pkg_name]["repo_dependency_cnt"] = str(present["repo_dependency_cnt"])
			results[curt_pkg_name]["collaborators_cnt"] = str(present["collaborators_cnt"])
			results[curt_pkg_name]["pm_keywords"] = str(present["pm_keywords"])
			results[curt_pkg_name]["repo_status"] = str(present["repo_status"])
			results[curt_pkg_name]["repo_keywords"] = str(present["repo_keywords"])
			results[curt_pkg_name]["repo_url"] = str(present["repo_url"])
			results[curt_pkg_name]["repo_description"] = str(present["repo_description"])
			results[curt_pkg_name]["language"] = str(present["language"])
			results[curt_pkg_name]["github_id"] = str(present["github_id"])
			results[curt_pkg_name]["star_cnt"] = str(present["star_cnt"])
			results[curt_pkg_name]["fork_cnt"] = str(present["fork_cnt"])
			results[curt_pkg_name]["version_cnt"] = str(present["version_cnt"])
			results[curt_pkg_name]["watcher_cnt"] = str(present["watcher_cnt"])
			results[curt_pkg_name]["last_update"] = str(present["last_update"])
			results[curt_pkg_name]["last_push"] = str(present["last_push"])
			results[curt_pkg_name]["size"] = str(present["size"])
			results[curt_pkg_name]["license"] = str(present["license"])
			results[curt_pkg_name]["private"] = str(present["private"])
			results[curt_pkg_name]["readMe"] = str(present["readMe"])
			results[curt_pkg_name]["homepage_url"] = str(present["homepage_url"])
			results[curt_pkg_name]["homepage_content"] = str(present["homepage_content"])
			results[curt_pkg_name]["path"] = str(present["path"])
			results[curt_pkg_name]["id"] = str(present["id"])

			# results[curt_pkg_name]
			results[curt_pkg_name]['_childDocuments_'] = []

		# Go over all the stackoverflow JSON object files
		for page in os.listdir(so_objects):
			with open(os.path.join(so_objects, page)) as json_file:
				source = {}
				source = json.load(json_file)

			# Parse the JSON object using BeautifulSoup
			with open(os.path.join(so_objects, page)) as file:
				soup = BeautifulSoup(file, "lxml")


			# Check if any page is related to "present"
			if soup.find(string=re.compile(curt_pkg_name)) is not None:
				current = {}
				current["link"] = str(source["link"])
				current["title"] = str(source["title"])
				current["tags"] = str(source["tags"])
				current["id"] = str(present["id"] + "-" + str(count))
				count = count + 1
				# current["_childDocuments_"] = source["answers"]

				if 'answers' in source:
					answers = []
					for ans in source["answers"]:
						ans["path"] = "3.stack.answer"
						ans["id"] = str(ans["answer_id"])
						answers.append(ans)
					current["_childDocuments_"] = answers

				current["up_vote_count"] = str(source["up_vote_count"])
				current["view_count"] = str(source["view_count"])
				current["answer_count"] = str(source["answer_count"])
				current["creation_date"] = str(source["creation_date"])
				if 'last_edit_date' in source:
					current["last_edit_date"] = str(source["last_edit_date"])
				current["body_markdown"] = str(source["body_markdown"])
				current["code_snippet"] = str(source["code_snippet"])
				current["path"] = "2.stack"
				results[curt_pkg_name]["_childDocuments_"].append(current)


	# Write to output files, one package per file
	for res in results:
		with open(output_folder + str(res) + ".json", 'w') as outfile:
			outfile.write("[")
			json.dump(results[res], outfile, indent=3)
			outfile.write("]")
		
		

	# Take out the outer package name
	# output = []
	# for res in results:
	# 	output.append(results[res])


	# Export the output
	# with open("output.json", 'w') as outfile:
	# 	json.dump(results, outfile)

if __name__ == "__main__":
	main()


















