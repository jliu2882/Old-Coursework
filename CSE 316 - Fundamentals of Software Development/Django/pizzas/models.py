from django.db import models

# Create your models here.
class Pizza(models.Model):
	"""A pizza the user wants to select"""
	name = models.CharField(max_length=200)
	date_added = models.DateTimeField(auto_now_add=True) 
	def __str__(self):
		"""Return a string representation of the model"""
		return self.name + " pizza"

class Topping(models.Model):
	"""A topping to put on a pizza"""
	pizza = models.ForeignKey(Pizza, on_delete=models.CASCADE)
	name = models.CharField(max_length=200)
	def __str__(self):
		"""Return a string representation of the model"""
		return self.name
