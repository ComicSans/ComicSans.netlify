---
layout: default
---

<h1 class="content-subhead">{% t global.welcome %}</h1>
{% tf welcome.md %}

<h1 class="content-subhead">{% t global.recent_blog_posts %}</h1>
<div class="posts">
  {% for post in site.posts %}
    <article class="post">
      <h2 class="post-title"><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a></h2>
      <div class="content">
        {{ post.excerpt }}
      </div>
      <a href="{{ site.baseurl }}{{ post.url }}" class="read-more">{% t global.read_more %}</a>
    </article>
  {% endfor %}
</div>
