import requests
import json
import pandas
import time

github_json = {}
url = "https://api.github.com/search/repositories?q="
readme_url = "https://raw.githubusercontent.com/"
concerned_columns = ["Repository Name with Owner","Repository Created Timestamp","Repository Stars Count","Repository Readme filename", "Repository Host Type","Description","Dependent Projects Count","Dependent Repositories Count","Platform","Repository Status",'Repository Keywords',"Repository Contributors Count",'Keywords']
i=0
#skiprows filed allows me to jump to where I left last time.
#have to use chunksize as small as possible otherwise the temporary memory that python reserved will be used up.
for aa in pandas.read_csv('library.csv',chunksize=1,iterator=True,index_col=False,usecols=concerned_columns, skiprows=range(1,71373)):
    print(i+71373)
    repo_manager = aa.get("Repository Host Type")[i]
    if repo_manager == "GitHub":
        star_cnt = aa.get("Repository Stars Count")[i]
        repo_name= aa.get("Repository Name with Owner")[i].split("/")[1]
        owner_name = aa.get("Repository Name with Owner")[i].split("/")[0]
        #repo_name = aa.get("Repository URL")[i].split("/")[4]
        #owner_name = aa.get("Repository URL")[i].split("/")[3]

        created_time = aa.get("Repository Created Timestamp")[i]
        if aa.get("description") is not None:
            description = aa.get("description")[i]
        else:
            description = None
        if star_cnt >=10:
            try:
                r = requests.get(url+ repo_name +"+user:" + owner_name +"+created:"+created_time.replace(' ','T',1).replace(' ','').replace('UTC','Z') , auth=("MSFeng","chrispaul243180"))
            except requests.ConnectionError:
                print('Failed to open url.')

            try:
                total_cnt = r.json()["total_count"]
            except:
                total_cnt = None
            if total_cnt != None and total_cnt>0:
                print(aa.get("Repository Name with Owner")[i])
                if r.json()["items"][0]["license"] is not None:
                    licenseName = r.json()["items"][0]["license"]["name"]
                else:
                    licenseName = None
                if r.json()["items"][0]["homepage"] is not None and r.json()["items"][0]["homepage"] is not '':
                    try: homepage_content = requests.get(r.json()["items"][0]["homepage"]).text
                    except:
                        print('Failed to open url.')
                        homepage_content = None
                else:
                    homepage_content= None
                if requests.get(r.json()['items'][0]['tags_url']).json() is not None:
                    version_cnt = len(requests.get(r.json()['items'][0]['tags_url']).json())
                else:
                    version_cnt = "not specified"
                if aa.get("Repository Readme filename") is not None:
                    readMe = requests.get(readme_url + owner_name + '/' + repo_name + '/master/' + str(aa.get("Repository Readme filename")[i])).text
                else:
                    readMe = None
                github_json[repo_name + "-" + owner_name]={
                    'name': repo_name,
                    'owner': owner_name,
                    'created_time': created_time,
                    "pm_description": description,
                    "pm_name":aa.get("Platform")[i],
                    "pm_dependency_cnt": str(aa.get("Dependent Projects Count")[i]),
                    "repo_dependency_cnt": str(aa.get("Dependent Repositories Count")[i]),
                    "collaborators_cnt": str(int(aa.get("Repository Contributors Count")[i])),
                    "pm_keywords":aa.get("Keywords")[i],
                    "repo_status": aa.get("Repository Status")[i],
                    'repo_keywords': aa.get('Repository Keywords')[i],
                    "repo_url": r.json()['items'][0]['html_url'],
                    "repo_description": r.json()['items'][0]['description'],
                    "language": r.json()['items'][0]["language"],
                    "github_id": r.json()['items'][0]["id"],
                    "star_cnt": r.json()["items"][0]['stargazers_count'],
                    "fork_cnt": r.json()["items"][0]['forks_count'],
                    "version_cnt": version_cnt,
                    "watcher_cnt": r.json()["items"][0]['watchers'],
                    "last_update":r.json()["items"][0]['updated_at'].replace('T',' ').replace('Z',' ')+' UTC',
                    "last_push": r.json()["items"][0]['pushed_at'].replace('T',' ').replace('Z',' ')+' UTC',
                    "size": r.json()["items"][0]["size"],
                    "license": licenseName,
                    "private": r.json()["items"][0]["private"],
                    "readMe":readMe,
                    "homepage_url":r.json()["items"][0]["homepage"],
                    "homepage_content": homepage_content
                    }
                time.sleep(2)

                with open('github.txt', 'a') as outfile:

                    json.dump(github_json[repo_name + "-" + owner_name], outfile, indent=3)

                    outfile.write("\n")
    i += 1













# for repo in r.json():
#
#     rr = requests.get(repo["stargazers_url"]+"?page=1"+"?client_id=f7e674d1a0aa0727e56f&client_secret=73f2f0ff8ccd38d3e0e65936efdc304a27974862")
#     i=2
#     star_list = rr.json()
    # while i<10:
    #     rr=requests.get(repo["stargazers_url"]+"?page=%d"%i)
    #     star_list.extend(rr.json())
    #     i+=1;



# with open('test2.txt','w') as file:
#     json.dump(rr.json(),file,indent = 4,
#                ensure_ascii = False)
#     json.dump(rrr.json(), file, indent=4,
#               ensure_ascii=False)