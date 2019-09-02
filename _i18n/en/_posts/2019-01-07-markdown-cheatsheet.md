---
layout: post
title: "Markdown Cheatsheet"
categories: [blog, jekyll, markdown]
---

Markdown is a text-to-HTML conversion tool for web writers. Markdown allows you to write using an easy-to-read, easy-to-write plain text format, then convert it to structurally valid XHTML (or HTML).

This post is intended as a quick reference and showcase.

Jekyll uses [Github flavored Markdown](https://help.github.com/categories/writing-on-github/).

<!--more-->

### Headers

~~~markdown
# H1
## H2
### H3
#### H4
~~~

### Emphasis

~~~markdown
_italic_
__bold__
~~~

### Lists

~~~markdown
* Item 1
* Item 2
* Item 3
~~~

### Links

~~~markdown
[I'm an inline-style link](https://www.google.com)
[I'm an inline-style link with title](https://www.google.com "Google's Homepage")
~~~

### Images

~~~markdown
![AltText](Link "TitleText")
~~~

### Code

~~~markdown
Inline `code` using back ticks
~~~
or multiline code like this:
~~~markdown
```javascript
var s = "JavaScript syntax highlighting";
alert(s);
```
~~~

### Tables
~~~markdown
| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |
~~~

### Blockquote
~~~markdown
> Blockquotes are very handy in email to emulate reply text.
> This line is part of the same quote.
~~~
