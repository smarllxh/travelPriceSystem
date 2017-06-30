#coding: utf-8

from django.shortcuts import render
from models import Target
# Create your views here.

def index(request):
	return render(request, 'index.html')
	pass
def result(request):
	return render(request, 'search.html')
	pass