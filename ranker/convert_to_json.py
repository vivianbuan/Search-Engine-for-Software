"""
A simple Python script to convert Github information in .txt file to JSON format

To run this script, run the command:
python convert_to_json.py <path/to/github.txt> <path/to/output.txt>
"""

import sys
import json
import simplejson


def main():
	# Filepath is obtained from user
	txt_filepath = sys.argv[1]
	json_dict = {}
	decoder = simplejson.JSONDecoder()

	# Read entire .txt file into string
	with open(txt_filepath) as f:
		content = f.readlines()
		cur_obj = ""

		for line in content:
			cur_obj += line

			# Identify the last line of the dictionary object
			if line == "}\n":
				# Parse string object into JSON format
				cur_dict, _ = decoder.raw_decode(cur_obj)
				json_dict[cur_dict["name"]] = cur_dict
				cur_obj = ""

				# Output to JSON file
				with open("github_JSON.json", 'w') as f:
					json.dump(json_dict, f)


if __name__ == "__main__":
	main()
