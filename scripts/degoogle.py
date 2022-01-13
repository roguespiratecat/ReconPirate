# Imports & Installs

from bs4 import BeautifulSoup
from re import search
import sys
import requests

url  = sys.argv[1]
print(sys.argv)
page = requests.get(url)
html_doc = page.text
if search('did not match any documents', html_doc) or search('Our systems have detected unusual traffic from your computer network', html_doc):
  None
else:
    print(f"[*] {url}")
    print("Found")
