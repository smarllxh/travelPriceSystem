# -*- coding: utf-8 -*-
import json
import requests
import re
import urllib
import scrapy

from scrapy_redis.spiders import RedisSpider

from MongoDB_Driver import *

class MySpider(RedisSpider):
    name = 'mainspider_redis'
    redis_key = 'disspider:start_urls'
    con = MongoDB_Driver()
    
    def new_ctrip_parser(self, response):
        place = re.findall('<title>(.*?)旅游', response.body)[0]
        travel_list = response.xpath('//div[@class="product_sublist flag_product flag_schedule  "]')

        for travel in travel_list:
            money = travel.xpath("div//strong/text()").extract()[0]
            json_string = ''
            for json_part in travel.xpath('./textarea/text()'):
                json_string = json_string + json_part.extract()
            ctrip_json = json.loads(json_string)
            data = {
                'destination': place,
                'go_way': '',
                'price': money,
                'hotel': '',
                'interests': ctrip_json['PackageName'],
                'data_start': '',
                'data_end': '',
                'comment': ctrip_json['Score'],
                'website': 'ctrip',
                'imageurl':''
            }
            self.con.db_insert('Data',data)

        if len(response.xpath('//a[@class="down "]')) == 1:
            sel = response.xpath('//a[@class="down "]')
            url = sel.xpath("@href").extract()[0]
            url = response.urljoin(url)
            yield scrapy.Request(url, callback=self.new_ctrip_parser)

    def qunar_parser(self, response):
        url = response.url
        place = re.findall('&fhLimit=0%2C20&q=(.*?)&d=', url)[0]
        place = urllib.unquote(place).decode('utf-8')
        mainjson = requests.get(response.url).json()
        groupcount = mainjson['data']['limit']['groupCount']
        page = 0
        count = 1
        while page < groupcount:
            temp_re = requests.get(url)
            mainjson = temp_re.json()
            maindata = mainjson['data']['list']['results']
            for littlejson in maindata:
                hotelinfo = ''
                interests = ''
                traffic = ''
                for subhotel in littlejson['hotelInfo']:
                    hotelinfo = hotelinfo + '+' + subhotel['name']
                for subinterest in littlejson['sights']:
                    interests = interests + '+' + subinterest
                for subtraffic in littlejson['summary']['traffic']:
                    traffic = traffic + subtraffic
                data = {
                    'destination': place,
                    'title': littlejson['title'],
                    'go_way': traffic,
                    'price': littlejson['price'],
                    'hotel': hotelinfo,
                    'interests': interests,
                    'data_start': '',
                    'data_end': '',
                    'comment': '',
                    'website': 'qunar',
                    'imageurl': littlejson['imgs']
                }
                self.con.db_insert('Data',data)
            url = url.replace('lm=' + str(page * 20) + '%2C20', 'lm=' + str((page + 1) * 20) + '%2C20')
            page = page + 1
            count = count + 1

    def parse(self, response):
        if 'dujia.qunar.com' in response.url:
            self.qunar_parser(response)
        elif 'ctrip.com' in response.url:
            yield scrapy.Request(response.url, callback=self.new_ctrip_parser)
        else:
            print 'unknown type of url'
