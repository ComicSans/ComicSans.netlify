---
layout: default
---

<h1 class="content-subhead">Welcome</h1>
This is the blog area of nerdwana.com - below you will find the most recent
blog posts. Please have a look at the [About page]({{ site.baseurl }}{% link _pages/about.md %}) for more details on this website.

<div class="posts">
  <h1 class="content-subhead">Recent blog posts</h1>
  {% for post in site.posts %}
    <article class="post">
      <h1 class="post-title"><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a></h1>
      <div class="entry post-description">
        {{ post.excerpt }}
      </div>
        <a href="{{ site.baseurl }}{{ post.url }}" class="read-more">{% t global.read_more %}</a>
    </article>
  {% endfor %}
</div>
