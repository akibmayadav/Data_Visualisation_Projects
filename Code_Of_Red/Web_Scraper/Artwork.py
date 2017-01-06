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
from collections import defaultdict

columns=defaultdict(list)
new_artist=[]
with open('Artist_Names.csv') as f:
    reader = csv.reader(f)
    for row in reader:
        for (i,v) in enumerate(row):
            columns[i].append(v)
artist = columns[1]
country = columns[0]

for a in range (0, len(artist)):
  n_artist = artist[a].replace(" ","-")
  new_artist.append(n_artist)


with session() as c:
  for i in range(7675,7704): # loop for artists
    for num in range(1,10): # loop for pages for every artist
      try:
        artwork_url = "http://www.wikiart.org/en/"+new_artist[i]+"/mode/all-paintings/"+str(num)
        response = requests.get(artwork_url, headers={'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.107 Safari/537.36','Upgrade-Insecure-Requests': '1','x-runtime': '148ms'}, allow_redirects=True).content
        soup =  BeautifulSoup(response, "html.parser")
        artwork_body = soup.find_all('body')
        for artwork_bodies in artwork_body :
          artwork_division = soup.find_all('ins',{'class':'search-item inline ie7_zoom'})
          for n in range(0, len(artwork_division)):
            count = 0 
            artwork_enc = artwork_division[n]
            artwork = artwork_enc.text.encode('utf-8').strip()
            artwork_name = artwork[0:len(artwork)-6]
            year_try = artwork[(len(artwork)-4):(len(artwork))]
            if (year_try[0] == '1') :
              year = year_try
            else :
              year = 0
            with open("Artwork_"+country[i]+"_Names.csv","a+") as a:
             fieldnames = ['Country','Artist','Artwork','Year']
             writer = csv.DictWriter(a, fieldnames=fieldnames)
             writer.writerow({'Country':country[i],'Artist':artist[i],'Artwork':artwork_name,'Year':year})
      except:
        print "a"
