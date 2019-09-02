---
layout: post
title: "Jekyll, Netlify and Cloudflare"
categories: [blog, jekyll, cloudflare, netlify]
---

This blog now moved to [Netlify](https://www.netlify.com) for hosting the static site content.

Previously, [Github Pages](https://pages.github.com) were used -  a great start for
hosting jekyll projects or other static content, but with a few drawbacks.

<!--more-->

Github Pages is dependent on the Github Pages gem and only supports a few plugins (see [here](https://pages.github.com/versions/)). While adding multilanguage support to this website (using [jekyll-multiple-languages-plugin](https://github.com/Anthony-Gaudino/jekyll-multiple-languages-plugin)), I reached a point where I needed another solution.

The Github Pages project is
- easy to use
- free of charge
- working well with Github and Cloudflare

So the new solution has to have the same advantages. And while some people use [Travis CI](https://travis-ci.org) or [CloudCannon](https://cloudcannon.com), I decided to go with Netlify.

## Why Netlify?

Well...

| Why not this? | Reason |
|---------------|:-------|
| Github Pages  | No general plugin support. This is a major drawback. |
| Travis CI     | Too much work upfront and another tool would be introduced. |
| CloudCannon   | It didn't work with the plugins needed ;) |
{: .pure-table .pure-table-horizontal }

## What is Netlify?

Netlify is a unified platform that *automates your code to create high-performant, easily maintainable sites, and web apps. They provide continuous deployment (Git-triggered builds), an intelligent, global CDN, full DNS (including custom domains), automated HTTPS, asset acceleration, and a lot more*.

In other words: you can connect your Github repository, define build settings like the output directory and the build command and have your deployment workflow automatically started whenever you `git push`. The resulting static page is available with a Netlify domain (like [this](http://comicsans.netlify.com)) or a custom domain.

### Connect netlify to github

The first step is to hook up netlify with your Github repo. They have a nice tutorial over [here](https://www.netlify.com/blog/2015/10/28/a-step-by-step-guide-jekyll-3.0-on-netlify/). The relevant build settings are:

{% picture default /images/netlify-build-settings.png alt="netlify build settings" %}

Also add your own domains here:

{% picture default /images/netlify-domain-settings.png alt="netlify domain settings" %}

## Using Cloudflare

[Cloudflare](https://www.cloudflare.com) speeds up and protects websites, APIs, SaaS services, and other properties connected to the Internet. They also auto minify the source code to removes unnecessary characters (like whitespace, comments, etc.) without changing its functionality and add caching.

Minification can compress source file size which reduces the amount of data that needs to be transferred to visitors and thus improves page load times.

### Using the correct nameservers

So the next step is to add Cloudflare to the stack. I have a custom domain where it set the nameservers to the ones provided by Cloudflare:

* jake.ns.coudflare.com
* lola.ns.cloudflare.com

### DNS settings

In the admin panel of Cloudflare I can set the correct CNAME DNS entries for my custom netlify domain:

{% picture default /images/cloudflare-dns.png alt="cloudflare dns" %}

A Canonical Name record (abbreviated as CNAME record) is a type of resource record which maps one domain name to another, referred to as the Canonical Name. CNAME records must always point to another domain name, never directly to an IP address.

In the security tab we can set an SSL certificate by chosing "SSL Full":

{% picture default /images/cloudflare-ssl.png alt="cloudflare ssl" %}

### What SSL setting should I use?

That setting controls how Cloudflare’s servers connect to our netlify domain (the origin) for HTTPS requests. Possible options are:

- **Flexible SSL**: You cannot configure HTTPS support on your origin, even with a certificate that is not valid for your site. Visitors will be able to access your site over HTTPS, but connections to your origin will be made over HTTP.
- **Full SSL**: Your origin supports HTTPS, but the certificate installed does not match your domain or is self-signed. Cloudflare will connect to your origin over HTTPS, but will not validate the certificate.
- **Full (strict)**: Your origin has a valid certificate (not expired and signed by a trusted CA or Cloudflare Origin CA) installed. Cloudflare will connect over HTTPS and verify the cert on each request.

Picking an incorrect setting (as "Full (strict)") results in your website not being available to visitors:

{% picture default /images/cloudflare-dns-error.png alt="cloudflare dns error" %}
