{% assign sortedCategories = site.categories | sort %}

{% for category in sortedCategories %}
  The Category "<em>{{ category[0] }}</em>" was found here:
  <ul>
    {% for post in category[1] %}
      <li><a rel="canonical"  href="{{ post.url }}">{{ post.title }}</a> ({{ post.date | date: "%d %b %Y" }})</li>
    {% endfor %}
  </ul>
{% endfor %}
