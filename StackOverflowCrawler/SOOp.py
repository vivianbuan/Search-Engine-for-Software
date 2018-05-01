import json
import os
import requests
# with open("SOJson.txt", 'rb+') as filehandle:
#     filehandle.seek(-3, os.SEEK_END)
#     filehandle.truncate()
# with open("SOJson.txt",'a') as filehandle:
#     filehandle.write("\n}")
# with open("aaa.txt",'w') as outfile:
#     data = json.load(open("githubJson.txt"))
#     json.dump(data,outfile,indent=3)
r = requests.get("http://www.SupermarketAPI.com/api.asmx/GetGroceries?APIKEY=61f3fd0b27&SearchText=App")
print(r.text)
