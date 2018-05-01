import requests
import json
from bs4 import BeautifulSoup
import pandas
import time

num = 390101
SO_json = {}
for i in range(3901,9950):
    print("i: "+str(i))
    r = requests.get("https://api.stackexchange.com/2.2/questions?pagesize=100&&page="+str(i)+"&order=desc&sort=votes&site=stackoverflow&filter=!*2)kzMzSQWRX8ft18Uvr0xVpEdNKsIUz5(2B.fIo-&key=AX2fbxbIc*ojr5YqwldSZg((")
    for j in range(0,100):
        print("num: "+str(num))
        temp = r.json()["items"][j]
        content = requests.get(temp["link"]).content
        soup = BeautifulSoup(content,"lxml")
        code = soup.findAll('code')
        codes = []
        for x in code:
            codes.append(str(x))
        temp["code_snippet"] = codes
        SO_json[str(num)] = temp

        with open('SOJsonOneLine.txt', 'a') as outfile:
            dump = json.dump(SO_json[str(num)], outfile)
            outfile.write("\n")
        num+=1
    if "backoff" in r.json():
        time.sleep(r.json()["backoff"])