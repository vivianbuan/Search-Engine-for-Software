"""
Purpose of this script is to obtain list of relevant SO question document for each package.

Number of packages : 95444
Number of unique packages : 61025
Number of SO documents : 385099
Number of SO documents labeled (unable to disambiguate between repeat labeling) : 318278

We will do this by first indexing all SO data into a local SOLR instance, then get a list of
packages that we want to label and loop over them, querying the SOLR instance with the package names.
If the name appears in the SO document at all, SOLR would record it in its response and return the
relevant question_id. At the end, we would end up with a dictionary, "package" : ["q_0", "q_1", ...],
that relates packages to their relevant SO questions via question_id.

Useful details on response from SOLR query:
{
    "responseHeader" : {
        "status" : 0,
        "QTime" : 0,
        "params" : {
            "q" : "Xcode-Templates"
        }
    },
    "response" : {
        "numFound" : 20351,
        "start" : 0,
        "docs" : [
            List of relevant SO files, according to our schema
        ]
    }
}

For each SO file, when accessing the key 'question_id', a list of question ids will be returned.

"""

from urllib import request
import json
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

# Counter for regular backing up of data
num_iter = 0

# Iterate over all packages in the list and query SOLR
for package in packagelist:
    # Output progress
    if num_iter % 1000 == 0:
        print("Done with labeling {} packages".format(num_iter))

    # Backupp data every 50000 packages
    if num_iter % 50000 == 0:
        with open('SOlabel.json', 'w') as f:
            json.dump(label_dict, f)

    # Check for repeat package names
    if package not in label_dict:
        num_iter = num_iter + 1

        # Current list of question ids
        cur_list = []

        # Open connection to SOLR server
        response = request.urlopen('http://localhost:8983/solr/stackoverflow/select?q=' + package)

        # Gets a byte string response
        response_bytes = response.read()

        # Convert byte string into json data
        response_json = response_bytes.decode('utf8')
        data = json.loads(response_json)

        # Extract the question ids
        for doc in data['response']['docs']:
            cur_list.extend(doc['question_id'])

        label_dict[package] = cur_list
