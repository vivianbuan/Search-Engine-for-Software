"""
A simple Python script to query the database created by Andrew's scripts

To run this script, run the command:
python query_slant.py <path/to/database.db> <path/to/output.json>
"""
import json
import sqlite3


# The languages we want to query one
languages = ["javascript", "python", "c++"]
qualifier = ["librar", ""]

# Connect to the database
conn = sqlite3.connect("./Package-Qualifiers/fetcher.db")
cur = conn.cursor()

# Get the related questions for each language
for language in languages:
    print "Querying for " + language + " related topics..."
    cur.execute("SELECT * FROM slanttopic WHERE title LIKE '%{}%'".format(language))
    result = cur.fetchall()
    print "Number of topics: " + str(len(result))

    for topic in result:
        print topic[4]
