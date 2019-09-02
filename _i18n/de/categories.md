{% assign sortedCategories = site.categories | sort %}

{% for category in sortedCategories %}
  Die Kategorie "<em>{{ category[0] }}</em>" wurde hier gefunden:
  <ul>
    {% for post in category[1] %}
      <li><a href="{{ post.url | prepend: '/de' + site.baseurl_root }}">{{ post.title }}</a> ({{ post.date | date: "%d %b %Y" }})</li>
    {% endfor %}
  </ul>
{% endfor %}
