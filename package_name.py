import json
import pandas

concerned_columns = ["Repository Name with Owner", "Repository Host Type"]
result = {}
result['packages'] = []

i = 0
for aa in pandas.read_csv('library.csv', chunksize=1, iterator=True, index_col=False, usecols=concerned_columns, skiprows=range(1000,2396750)):
	repo_manager = aa.get("Repository Host Type")[i]
	if repo_manager == "GitHub":
		repo_name= aa.get("Repository Name with Owner")[i].split("/")[1]
		result['packages'].append(repo_name)
	i += 1


with open("names.json", 'w') as outfile:
	json.dump(result, outfile)

