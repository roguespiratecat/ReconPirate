import json

f = open('gdorks.json')

data = json.load(f)
for i in data:
    print(i['url'])

