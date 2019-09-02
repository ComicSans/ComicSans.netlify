---
layout: post
title: "How to translate a Jekyll site"
categories: [blog, jekyll, plugins, howto]
---

This blog is available in two language: English and German. You can switch between the languages in the top right corner (at the time of writing at least). In this blog post I will write down the steps necessary to archive this.

<!--more-->

## The plugin

We use the plugin [jekyll-multiple-languages-plugin](https://github.com/Anthony-Gaudino/jekyll-multiple-languages-plugin).

Add this to your Gemfile:

```ruby
group :jekyll_plugins do
   gem 'jekyll-multiple-languages-plugin'
end
```

and run `bundle install`.

Activate the plugin in your Jekyll config:

```yaml
plugins:
  - jekyll-multiple-languages-plugin

languages: ['en', 'de']
  exclude_from_localizations: ["javascript", "images", "css"]
  language_default: 'en'
  languageNames:
    de: DE
    en: EN
```
I also added two languages, English and German. The default language of the website is set to English.

### How to organize your files

Next, you have to create the correct folder. All translated posts will be put into the _\_i18n_ subfolder:

{% picture small /images/jekyll-i18n-folder-structure.png alt="jekyll folder structure" %}

Blog posts go to _\_i18n/en/\_posts_ for English entries and _\_i18n/de/\_posts_. The static pages end up in _\_i18n/en_ or _\_i18n/de_ directly.

We keep the original _\_pages_ folder. The previous _\_posts_ folder is moved permanently to _\_i18n_.

## The language switcher

I use [Pure](https://purecss.io) for styling, so don't care about the `pure.button-group` classes in the code.

{% raw %}
```html
<div class="pure-button-group language_switcher" role="group" aria-label="...">
{% for lang in site.languageNames \%\}
  {% if lang[0] == site.language_default %}
    {% if lang[0] == site.lang %}
      <a class="pure-button pure-button-active" href="{{ site.baseurl_root }}/">{{ lang[1] }}</a>
    {% else %}
      <a class="pure-button" href="{{ site.baseurl_root }}/">{{ lang[1] }}</a>
    {% endif %}
  {% else %}
    {% if lang[0] == site.lang %}
      <a class="pure-button pure-button-active" href="{{ site.baseurl_root }}/{{ lang[0] }}/">{{ lang[1] }}</a>
    {% else %}
      <a class="pure-button" href="{{ site.baseurl_root }}/{{ lang[0] }}/">{{ lang[1] }}</a>
    {% endif %}
  {% endif %}
{% endfor %}
</div>
```
{% endraw %}

## Changes to the templates

### General

In my default layout I set the HTML tag like this:

{% raw %}
```html
<!DOCTYPE html>
<html lang="{{ site.lang }}">
```
{% endraw %}

I also changed the site's tagline like this:

{% raw %}
```html
<div class="site-info">
  <h1 class="site-name"><a href="{{ site.baseurl }}/">{{ site.name }}</a></h1>
  <p class="site-description">{% t global.description  %}</p>
</div>
```
{% endraw %}

And here you can see the translation for the first time.
{% raw %}`{% t global.description}`{% endraw %} translates the site description based on the language the user has selected (and defaulting to english).

But where does the translation come from?

That's were the yaml files in _\_i18n_ are used:

```yaml
#_i18n/en.yml - english
global:
  description: Welcome to nerdwana
  about: About
  categories: Categories
  filed_under: Filed under
  read_more: Read more
  welcome: welcome
  recent_blog_posts: Recent blog posts
  404-page-not-found: 404 - Page not found
```
The corresponding file for the German translation looks like this:

```yaml
#_i18n/de.yml - german
global:
  description: Willkommen im nerdwana
  about: Über
  categories: Kategorien
  filed_under: Eingeordnet unter
  read_more: Weiterlesen
  welcome: Willkommen
  recent_blog_posts: Kürzliche Blogeinträge
  404-page-not-found: 404 - Page not found
```

The string `global.description` is used for the tagline above. The remaining entries are used in the navigation or in the post layout (you can see examples later in the blog post):

{% raw %}
```html
<div class="custom-wrapper pure-g" id="menu">
    <div class="pure-u-1 pure-u-md-1-2">
        <div class="pure-menu">
            <a href="{{ site.baseurl }}/" class="pure-menu-heading custom-brand" style="text-transform: none; color: #777;">Blog</a>
            <a href="#" class="custom-toggle" id="toggle"><s class="bar"></s><s class="bar"></s></a>
        </div>
    </div>
    <div class="pure-u-1 pure-u-md-1-2">
        <div class="pure-menu pure-menu-horizontal custom-menu-3 custom-can-transform">
            <ul class="pure-menu-list">
                <li class="pure-menu-item"><a href="{{ site.baseurl }}/categories" class="pure-menu-link">{% t global.categories %}</a></li>
                <li class="pure-menu-item"><a href="{{ site.baseurl }}/about" class="pure-menu-link">{% t global.about %}</a></li>
            </ul>
        </div>
    </div>
</div>
```
{% endraw %}

### Links

Use _baseurl_root_ for CSS files:

```html
{% raw %}<link rel="stylesheet" href="{{ "/your.css" | prepend: site.baseurl_root }}"/>{% endraw %}
```

### Posts

Posts go to the `_posts` subfolder. The rest should work out of the box. A visitor will only see posts in the selected language, if you use `site.posts`:

{% raw %}
```html
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
```
{% endraw %}

### Pages

What about pages? They are a bit more complicated as you don't want to link them for every language separately. We don't use the `t` or `translate` method here but `tf` to translate whole files.

First create a page stub in the `_pages` folder outside of `_i8n` like this:

{% raw %}
```yml
#_pages/about.md
---
layout: page
title: About
permalink: /about/
---
{% tf about.md %}
```
{% endraw %}

This will look for a file `about.md` in the language specific `_i18n` subfolder.

Next add the corresponding translation to either `_i18n/en` or `_i18n/de`:

{% raw %}
```markdown
#_i18n/en/about.md - the english version of this file
This is the About page.
```
{% endraw %}
