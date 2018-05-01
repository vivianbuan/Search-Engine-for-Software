import json
import requests
import time

import os
# with open("githubJson.txt", 'rb+') as filehandle:
#     filehandle.seek(-3, os.SEEK_END)
#     filehandle.truncate()
# with open("githubJson.txt",'a') as filehandle:
#     filehandle.write("\n}")
# with open("aaa.txt",'w') as outfile:
#     data = json.load(open("githubJson.txt"))
#     json.dump(data,outfile,indent=3)
#
i =20697
with open("newGithubJsonOneLine.txt",'r+') as f:
    for j in range(20697):
        f.readline()
    for line in f:
        print(i)
        i+=1
        idx = line.find('{')
        line = line[idx:]
        data = json.loads(line)
        name = data['name']
        owner = data['owner']
        url = data['homepage_url']
        if url is not None:
            if "https:/" in url:
                url = url[7:]
            if "http:/" in url:
                url = url[6:]
            r = requests.get("http://favicongrabber.com/api/grab/" + url)
            if r is not None:
                jsonObj = r.json()
                if "error" not in jsonObj:
                    jsonObj["name"] = name
                    jsonObj["owner"] = owner
                    with open('newIcon.txt', 'a') as outfile:
                        quotes = '"'
                        outfile.write(quotes + name + '--' + owner + quotes + ": ")
                        dump = json.dump(jsonObj, outfile)
                        outfile.write("\n")
            time.sleep(1)

# with open("githubJsonOneLine.txt",'r') as f:
#     for line in f:
#         idx = line.find('{')
#         line = line[idx:]
#         data = json.loads(line)
#         name = data['name']
#         owner = data['owner']
#         url = data['homepage_url']
#         if url is not None:
#             if "https:/" in url:
#                 url = url[7:]
#             if "http:/" in url:
#                 url = url[6:]
#             r = requests.get("http://favicongrabber.com/api/grab/" + url)
#             jsonObj = r.json()
#             print(jsonObj)
