from django import template
from markdownx.utils import markdownify

register = template.Library()

@register.simple_tag
def dictKeyLookup(the_dict, key):
   # Try to fetch from the dict, and if it's not found return an empty string.
   return the_dict.get(key, '')

@register.filter
def show_markdown(text):
   return markdownify(text)

@register.filter
def get_at_index(list, index):
    return list[index]