from requests import session
import os.path
import subprocess
import pickle
import sys
from bs4 import BeautifulSoup, Comment
import HTMLParser
import urllib2
import csv
with session() as c:
    # Looping over the year and months to get the data over the months from 2006 to 2015.
 for yr in range (2006,2016):
    for mon in range (1,13) :
       if ((mon == 1) or (mon == 3) or (mon == 5) or (mon == 7) or (mon == 8) or (mon == 10) or (mon == 12)):
        last=32
       else :
        if ((mon == 4) or (mon == 6) or (mon == 9) or (mon == 7) or (mon == 11)):
         last=31
        else :
         if (mon == 2) and ((yr == 2008) or (yr == 2012)):
           last=30
         else :
           last=31
       for date in range (1,last) :
            datestr = str(yr)+"/"+str(mon)+"/"+str(date)
            dateprint=str(yr)+"-"+str(mon)+"-"+str(date)
            weather_url = "http://www.wunderground.com/history/airport/KBFI/"+datestr+"/DailyHistory.html?&reqdb.zip=&reqdb.magic=&reqdb.wmo=&MR=1"
            response = c.get(weather_url)
            soup =  BeautifulSoup(response.content, "html.parser")
            #print soup
            table_all = soup.find_all('table', {"id" : "historyTable"})
            #print table_all
            for table in table_all:
              tbodies = table.findAll('tbody')
              for tbody in tbodies:
                     td= tbody.findAll("td")
                     avg_temp=td[3]
                     avg_temp=str(avg_temp.text.encode('utf-8').strip())[:-3]
                     break


            with open("weather_temp.csv","a+") as a:
             fieldnames = ['Date','Avg_Temp']
             writer = csv.DictWriter(a, fieldnames=fieldnames)
             writer.writerow({'Date':dateprint,'Avg_Temp':avg_temp})