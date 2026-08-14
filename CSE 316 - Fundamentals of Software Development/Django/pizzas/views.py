from django.shortcuts import render
from .models import Pizza

# Create your views here.
def index(request):
	"""Show available pizzas"""
	pizzas = Pizza.objects.order_by('date_added')
	context = {'pizzas': pizzas}
	return render(request, 'pizzas/index.html', context)

def pizza(request, pizza_id):
	"""Show a single pizza and all its toppings."""
	pizza = Pizza.objects.get(id=pizza_id)
	toppings = pizza.topping_set.order_by('id')
	context = {'pizza': pizza, 'toppings': toppings}
	return render(request, 'pizzas/pizza.html', context)
