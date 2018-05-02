"""
Before using this script please clone the repo from https://github.com/andrewhead/Package-Qualifiers,
follow the instructions on the script to get the slant topics and put this script into the cloned
directory. 

Given a list of packge names in packagenames.txt, this script goes through the DB of slant queries and
answers to look for queries that are relevant to the package list we have. The output is a JSON file named slantlabel.json
that contains:

{"package1": ["Query 1 linked to package 1", "Query 2 linked to package 1", ...],
 "package2": ["Query 1 linked to package 2", "Query 2 linked to package 2", ...],
 ...
}
"""
import json
import sqlite3
import pprint


# Initial PrettyPrinter
pp = pprint.PrettyPrinter(indent=4)

# Initialize dict to return
label_dict = {}

# Get list of packages from .txt file
fname = "./packagenames.txt"
with open(fname) as f:
    packagelist = f.readlines()

# Strip \n character at the end of each line
packagelist = [x.strip() for x in packagelist]

# Get list of packages from new list as well
fname = "./newpackages.txt"
with open(fname) as f:
    newpackagelist = f.readlines()

# Strip \n character at the end of each line
newpackagelist = [x.strip() for x in newpackagelist]

# Concatenate the lists
packagelist = packagelist + newpackagelist

# Connect to DB
conn = sqlite3.connect("fetcher.db")

# Get list of slant queries
cur = conn.cursor()
cur.execute("SELECT * FROM slanttopic")
slanttopic_result = cur.fetchall()

# For each slant query, check if answers are in package list,
# if yes then record query into label_dict
for topic in slanttopic_result:
    cur.execute("SELECT * FROM viewpoint WHERE topic_id LIKE {}".format(topic[0]))
    answers = cur.fetchall()
    for answer in answers:
        # Check if answer is in package list
        if answer[5] in packagelist:
            if answer[5] not in label_dict:
                label_dict[answer[5].encode('ascii', 'ignore')] = []
            
            label_dict[answer[5].encode('ascii', 'ignore')].append(topic[4].encode('ascii', 'ignore'))

pp.pprint(label_dict)

# Write label_dict out into a JSON file
with open('slantlabel.json', 'w') as f:
    json.dump(label_dict, f)
