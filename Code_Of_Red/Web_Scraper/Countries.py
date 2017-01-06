from requests import session 
import requests
import os.path
import subprocess
import pickle
import sys
from bs4 import BeautifulSoup, Comment
import HTMLParser
import urllib2
import csv
with session() as c:
  nationality_url = "http://www.wikiart.org/en/artists-by-nation"
  response = requests.get(nationality_url, headers={'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.107 Safari/537.36','Upgrade-Insecure-Requests': '1','x-runtime': '148ms'}, allow_redirects=True).content
  soup =  BeautifulSoup(response, "html.parser")
  body = soup.find_all('body')
  for bodies in body :
    division = soup.find_all('h6',{'class':'artist-grouped'})
    for i in range(0, len(division)-1):
      count = 0 ;
      country_enc = division[i]
      country = country_enc.text.encode('utf-8').strip()
      for j in range(0,len(country)):
        if country[j] != "(" :
         count = count +1 
        else : break
      country_name = country[0:count]
      with open("List_Of_Countries.csv","a+") as a:
        fieldnames = ['Country']
        writer = csv.DictWriter(a, fieldnames=fieldnames)
        writer.writerow({'Country':country_name})