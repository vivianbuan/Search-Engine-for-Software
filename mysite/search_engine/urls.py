from django.conf.urls import url
from . import views


urlpatterns = [
	url(r'^$', views.index, name='index'),
	url(r'results', views.results, name='results'),
	url(r'_ajax_reload_carousel', views._ajax_reload_carousel, name='_ajax_reload_carousel')
]