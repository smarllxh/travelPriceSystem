#!/bin/bash 
ps -eaf|grep mongo|grep -v grep |grep -v /usr |awk '{print $2}'|xargs kill -9
