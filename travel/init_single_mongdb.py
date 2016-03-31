#!/usr/bin/env python
# coding=utf-8
'''
the file is used to init the single mogodb
doc={'destination':
      'go_way':
      'price':
      'hotel':
      'interests':
      'data_start':
      'data_end':
     }

'''
from pymongo import MongoClient

DATABASE_HOST="localhost"
DATABASE_NAME="Travel"
DATABASE_PORT=27017
client=None
INDEX = {\
         #collection
         'way_detail':\
         {\
          'destination':{'name':'destination'},
          'price':{'name':'price'},
          'go_way':{'name':'go_way'},
         }\
        }
def dropDatabase(database_name):
    if database_name and client:
        client.drop_database(database_name)

def creatIndex():
    for k,v in INDEX.items():
        for key,kwargs in v.items():
            print(key)
            client[DATABASE_NAME][k].ensure_index(key,**kwargs)

if __name__=="__main__":
    client=MongoClient(DATABASE_HOST,DATABASE_PORT)
    dropDatabase(DATABASE_NAME)
    creatIndex()
    print("init success!")
