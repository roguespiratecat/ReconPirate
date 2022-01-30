import requests

# The Request data will come converted curl commands f12 trick!

def makeRequest(attackVector):
    vector = f"{attackVector}"
    headers = {
       #Headers
    }

    params = (
      #params
    )

    data = {
     # data
    }

    response = requests.post('targetUrl', headers=headers, params=params, data=data)
    print(response.text)

file = open("injections.txt",'r')
while True:
    next_line = file.readline()

    if not next_line:
        break;
    attackVector= next_line.strip()
    # call the Endpoint
    print(f"making request with Attack Vector {attackVector}")
    makeRequest(attackVector)
file.close()
