import sys
import json
import os
import re

# GitHub JSON objects are in "gh_objects"
# StackOverflow JSON objects are in "so_objects"
# Output files should be in "output"


def main():
	gh_objects_dir = sys.argv[1]
	so_objects_dir = sys.argv[2]
	output_dir = sys.argv[3]

	with open("SOlabel.json") as label:
		dictionary = {}
		dictionary = json.load(label)

	pos = 86000
	# Iterate over every GitHub object
	# for gh in os.listdir(gh_objects_dir):
	while pos < 95444:
		# print(pos)
		pos = pos + 1
		# with open(os.path.join(gh_objects_dir, gh)) as gh_obj:
		with open(os.path.join(gh_objects_dir, str(pos))) as gh_obj:
			current = {}
			current = json.load(gh_obj)
			
		curt_name = current["name"]
		# print(curt_name)
		current["path"] = "1.git"
		current["id"] = str(current["github_id"])

		current["created_time"] = str(current["created_time"])
		current["pm_description"] = str(current["pm_description"])
		current["pm_dependency_cnt"] = str(current["pm_dependency_cnt"])
		current["repo_dependency_cnt"] = str(current["repo_dependency_cnt"])
		current["collaborators_cnt"] = str(current["collaborators_cnt"])
		current["pm_keywords"] = str(current["pm_keywords"])
		current["repo_status"] = str(current["repo_status"])
		current["repo_keywords"] = str(current["repo_keywords"])
		current["repo_url"] = str(current["repo_url"])
		current["repo_description"] = str(current["repo_description"])
		current["language"] = str(current["language"])
		current["github_id"] = str(current["github_id"])
		current["star_cnt"] = str(current["star_cnt"])
		current["fork_cnt"] = str(current["fork_cnt"])
		current["version_cnt"] = str(current["version_cnt"])
		current["watcher_cnt"] = str(current["watcher_cnt"])
		current["last_update"] = str(current["last_update"])
		current["last_push"] = str(current["last_push"])
		current["size"] = str(current["size"])
		current["license"] = str(current["license"])
		current["private"] = str(current["private"])
		current["readMe"] = str(current["readMe"])
		current["homepage_url"] = str(current["homepage_url"])
		temp = str(current["homepage_content"])
		current["homepage_content"] = temp 
		current["path"] = str(current["path"])
		current["id"] = str(current["id"])

		current['_childDocuments_'] = []
		if str(curt_name) not in dictionary:
			continue
		match_list = dictionary[str(curt_name)]
		count = 0

		for match in match_list:
			with open(os.path.join(so_objects_dir, str(match))) as so_obj:
				child = {}
				child = json.load(so_obj)

			child["link"] = str(child["link"])
			child["title"] = str(child["title"])
			child["tags"] = str(child["tags"])
			child["id"] = str(current["id"] + "-" + str(count))
			count = count + 1

			if 'answers' in child:
				answers = []
				for ans in child["answers"]:
					ans["path"] = "3.stack.answer"
					ans["id"] = str(ans["answer_id"])
					answers.append(ans)
				child["_childDocuments_"] = answers
			if 'migrated_from' in child:
				child["migrated_from"] = ""

			child["answers"] = ""
			child["up_vote_count"] = str(child["up_vote_count"])
			child["view_count"] = str(child["view_count"])
			child["answer_count"] = str(child["answer_count"])
			child["creation_date"] = str(child["creation_date"])
			if 'last_edit_date' in child:
				child["last_edit_date"] = str(child["last_edit_date"])
			child["body_markdown"] = str(child["body_markdown"])
			child["code_snippet"] = str(child["code_snippet"])
			child["path"] = "2.stack"
			current["_childDocuments_"].append(child)

		with open(output_dir + str(curt_name) + ".json", 'w') as outfile:
			outfile.write("[")
			json.dump(current, outfile, indent=3)
			outfile.write("]")


if __name__ == "__main__":
	main()



