import requests
import json
import pandas
import time
import csv

csv_file = csv.DictReader(open('library.csv', "r"))
libraryIO = []
github_json ={}
repo_name ="vue"
owner_name = "vuejs"
readme_url = "https://raw.githubusercontent.com/"
for row in csv_file:
    #if current rows 2nd value is equal to input, print that row
    if owner_name+'/'+repo_name == row["Repository Name with Owner"]:
        libraryIO = row
r = requests.get("https://api.github.com/search/repositories?q="+ repo_name +"+user:" + owner_name,auth=("MSFeng","chrispaul243180"))
if requests.get(r.json()['items'][0]['tags_url']).json() is not None:
    version_cnt = len(requests.get(r.json()['items'][0]['tags_url']).json())
else:
    version_cnt = "not specified"
if r.json()["items"][0]["license"] is not None:
    licenseName = r.json()["items"][0]["license"]["name"]
else:
    licenseName = None
if libraryIO.get("Repository Readme filename") is not None:
    readMe = requests.get(
        readme_url + owner_name + '/' + repo_name + '/master/' + str(libraryIO.get("Repository Readme filename"))).text
    readMe = readMe.replace("{", '').replace('}', '')
else:
    readMe = None
if r.json()["items"][0]["homepage"] is not None and r.json()["items"][0]["homepage"] is not '':
    try:
        homepage_content = requests.get(r.json()["items"][0]["homepage"]).text
        #homepage_content = homepage_content.replace("{", '').replace('}', '')
    except:
        print('Failed to open url.')
        homepage_content = None
else:
    homepage_content = None
github_json[repo_name + "--" + owner_name] = {
    'name': repo_name,
    'owner': owner_name,
    'created_time': libraryIO.get("Repository Created Timestamp"),
    "pm_description": libraryIO.get("description"),
    "pm_name": libraryIO.get("Platform"),
    "pm_dependency_cnt": str(libraryIO.get("Dependent Projects Count")),
    "repo_dependency_cnt": str(libraryIO.get("Dependent Repositories Count")),
    "collaborators_cnt": str(int(libraryIO.get("Repository Contributors Count"))),
    "pm_keywords": libraryIO.get("Keywords"),
    "repo_status": libraryIO.get("Repository Status"),
    'repo_keywords': libraryIO.get('Repository Keywords'),
    "repo_url": r.json()['items'][0]['html_url'],
    "repo_description": r.json()['items'][0]['description'],
    "language": r.json()['items'][0]["language"],
    "github_id": r.json()['items'][0]["id"],
    "star_cnt": r.json()["items"][0]['stargazers_count'],
    "fork_cnt": r.json()["items"][0]['forks_count'],
    "version_cnt": version_cnt,
    "watcher_cnt": r.json()["items"][0]['watchers'],
    "last_update": r.json()["items"][0]['updated_at'].replace('T', ' ').replace('Z', ' ') + ' UTC',
    "last_push": r.json()["items"][0]['pushed_at'].replace('T', ' ').replace('Z', ' ') + ' UTC',
    "size": r.json()["items"][0]["size"],
    "license": licenseName,
    "private": r.json()["items"][0]["private"],
    "readMe": readMe,
    "homepage_url": r.json()["items"][0]["homepage"],
    "homepage_content": homepage_content
}
with open('newnewGithubJsonOneLine.txt', 'a') as outfile:
    quotes = '"'
    outfile.write(quotes + repo_name + '--' + owner_name + quotes + ": ")
    dump = json.dump(github_json[repo_name + "--" + owner_name], outfile)
    outfile.write("\n")
