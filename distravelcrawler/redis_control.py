import redis
import urllib2
import requests
import re
from os.path import exists

'''
Here is the main startup of the redis-server which mainly do the job to push all the requiring url to the host
disspider:place holds all the place's travel info to be crawled 
disspider:start_urls holds all the url need to be crawled
'''
index_url = 'http://vacations.ctrip.com/tours'
index_re = requests.get(index_url)
index_content = index_re.content.decode('gbk')
index_content = index_content.split('<div class="sel_list">')[1]
place_list = re.findall('<a href="/you/.*?" title="(.*?)">.', index_content)
try:
    if exists('start_setting.py'):
        print 'haha this function do not implement now'
    else:
        r = redis.StrictRedis(host='127.0.0.1', port=6379, db=0)
except:
    print 'Connetion can not be established'
r.delete('disspider:place')
r.delete('disspider:start_urls')

for place_name in place_list:
    ctrip_url = 'http://vacations.ctrip.com/tours' + '/' + re.findall('<a href="/you/(.*?)" title="' + place_name + '"', index_content)[0]
    qunar_url = 'http://dujia.qunar.com/golfz/routeList/adaptors/pcTop?isTouch=0&t=all&o=pop-desc&lm=0%2C20&fhLimit=0%2C20&q=' \
                  + urllib2.quote(place_name.encode('utf-8')) + '&d=' + urllib2.quote(place_name.encode('utf-8')) + \
                  '&s=all&qs_ts=1456622674653&tf=qunarindex&ti=3&tm=djnull&sourcepage=list' \
                '&qssrc=eyJ0cyI6IjE0NTY2MjI2NzQ2NTMiLCJzcmMiOiJhbGwuZW52YSIsImFjdCI6InNlYXJjaCJ9' \
                '&m=l%2CbookingInfo%2Clm&displayStatus=pc&lines6To10=0'
    r.lpush('disspider:place', place_name)
    #r.lpush('disspider:start_urls', qunar_url)
    r.lpush('disspider:start_urls', ctrip_url)
