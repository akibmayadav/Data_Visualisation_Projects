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

country=[]
with open('List_Of_Countries.csv') as csvfile:
    spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
    for row in spamreader:
        country.append('+'.join(row))

with session() as c:
  for i in range(0,len(country)):
    for num in range(1,10):
        try:
          artist_url = "http://www.wikiart.org/en/artists-by-nation/"+country[i]+"/"+str(num)
          response = requests.get(artist_url, headers={'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.107 Safari/537.36','Upgrade-Insecure-Requests': '1','x-runtime': '148ms'}, allow_redirects=True).content
          soup =  BeautifulSoup(response, "html.parser")
          artist_body = soup.find_all('body')
          for artist_bodies in artist_body :
           artist_division = soup.find_all('ins',{'class':'search-item inline ie7_zoom'})
           for n in range(0, len(artist_division)):
            count = 0 
            artist_enc = artist_division[n]
            artist = artist_enc.text.encode('utf-8').strip()
            for j in range(0,len(artist)):
             if artist[j] != "," :
              count = count +1 
             else : break
            artist_name = artist[0:count]
            with open("Artist_Names.csv","a+") as a:
             fieldnames = ['Country','Artist']
             writer = csv.DictWriter(a, fieldnames=fieldnames)
             writer.writerow({'Country':country[i],'Artist':artist_name})
        except:
                 print " "
