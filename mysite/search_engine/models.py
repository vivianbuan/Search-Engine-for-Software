from django.db import models

# Create your models here.
'''
Welp, there will be a lot to change here. Just some basic setup for now
'''
class Result(models.Model):
	url = models.CharField(max_length=250)
	link_name = models.CharField(max_length=500)
	text_snippet = models.CharField(max_length=2000)

class Package(models.Model):
	url = models.CharField(max_length=250)
	name = models.CharField(max_length=100)
	#and lots of more metadata to include here


class ResultCollection(object):

	def __init__(self, num_items = 10):
		self.num_items = []
		self.items = []

	def populate(query = ""):
		#use the query to filter out objects and populate the model
		pass

	def test_populate():
		pass


class PackageColletion(object):

	pass
