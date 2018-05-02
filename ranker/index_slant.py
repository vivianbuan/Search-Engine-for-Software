"""
Before using this script please clone the repo from https://github.com/andrewhead/Package-Qualifiers,
follow the instructions on the script to get the slant topics and put this script into the cloned
directory. 

The purpose of this script is to upload slant queries to their relevant packages
"""
import requests
import json
import pprint
from urllib import request


# Initialize PrettyPrinter
pp = pprint.PrettyPrinter(indent=4)

# Information of Solr server to index to
url = "http://localhost:8983/solr/nestedpackage/update?commit=true"
headers = {'Content-type': 'text/json'}

# Open file with all packages and their related slant queries
with open('slantlabel.json') as json_data:
    slant_dict = json.load(json_data)

# Index the slant queries package by package
for package, queries in slant_dict.items():
    # First obtain the id of the package
    response = request.urlopen('http://localhost:8983/solr/nestedpackage/select?q=name:"' + package +'"')

    # Gets a byte string response
    response_bytes = response.read()

    # Convert byte string into json data
    response_json = response_bytes.decode('utf8')
    data = json.loads(response_json)

    # Get the id of the package
    for doc in data['response']['docs']:
        print(doc['id'])

        # Index the package's queries
        payload = '[{"id": "' + doc['id'] + '", "slant_query": {"set": ' + str(queries) + '}}]'
        r = requests.post(url, headers=headers, data=payload)
        print(r.text)
