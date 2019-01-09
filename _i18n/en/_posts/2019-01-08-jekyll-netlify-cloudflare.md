---
layout: post
title: "Jekyll, Netlify and Markdown"
categories: [blog, jekyll, markdown, netlify]
---

This blog now moved to [Netlify](https://www.netlify.com) for hosting the static site content.

Previously, [Github Pages](https://pages.github.com) were used -  a great start for
hosting jekyll projects or other static content, but with a few drawbacks.

<!--more-->

Github Pages is dependent on the Github Pages gem and only supports a few plugins (see [here](https://pages.github.com/versions/)). While adding multilanguage support to this website (using [jekyll-multiple-languages-plugin](https://github.com/Anthony-Gaudino/jekyll-multiple-languages-plugin)), I reached a point where I needed another solution.

Github Pages is
- easy to use
- free of charge
- working well with Github and Cloudflare

So the new solution has to have the same advantages. And while some people use [Travis CI](https://travis-ci.org) or [CloudCannon](https://cloudcannon.com), I decided to go with Netlify.

## Why Netlify?

Well...

| Why not this? | Reason |
|---------------|:-------|
| Github Pages  | No general plugin support |
| Travis CI     | Too much work upfront and another tool |
| CloudCannon   | It didn't work with the plugins needed ;) |
{: .pure-table .pure-table-horizontal }

## What is Netlify?

Netlify is a unified platform that automates your code to create high-performant, easily maintainable sites, and web apps. They provide continuous deployment (Git-triggered builds), an intelligent, global CDN, full DNS (including custom domains), automated HTTPS, asset acceleration, and a lot more.

So you can connect your Github repository, define build settings like the output directory and the build command and have your deployment workflow automatically started whenever you git push. The resulting static page is available with a Netlify domain (like [this](http://comicsans.netlify.com)) or a custom domain.


_to be continued..._
