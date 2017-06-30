# coding:utf-8

from __future__ import unicode_literals
from django.contrib import admin
from django.db import models

# Create your models here.

class Target(models.Model):
	destination = models.CharField(max_length = 150, blank = True, default = '江西吉安')
	go_way = models.CharField(max_length = 100, blank = True, default = 'airplane')
	price = models.DecimalField(max_digits = 12, decimal_places = 2, blank = True, default = '1999.99')
	hotel = models.CharField(max_length = 100, blank = True ,default = '如家连锁酒店')
	interests = models.CharField(max_length = 150, blank = True ,default = '红色旅游、革命摇篮、古镇乡村、人文景观')
	data_start = models.CharField(max_length = 100, blank = True ,default = '现在就走')
	data_end = models.CharField(max_length = 100, blank = True ,default = '就在那里定居吧')
	comment = models.CharField(max_length = 150, blank = True ,default = '满分')
	website = models.CharField(max_length = 100, blank = True ,default = 'http://vacations.ctrip.com/grouptravel/p5687321s2.html')
	imageurl = models.CharField(max_length = 100, blank = True ,default = 'http://dimg04.c-ctrip.com/images/vacations/images2/1/876/876_70_s28263_C_500_280.jpg')

	def __unicode__(self):
		return self.destination
		pass
admin.site.register(Target)
class spider(models.Model):
	targetURL = models.URLField(max_length = 150, blank = False)
	time = models.DateField(auto_now = False, auto_now_add = False, blank = False)
	name = models.CharField(max_length = 100)

	def __unicode__(self):
		return self.name
		pass
admin.site.register(spider)
