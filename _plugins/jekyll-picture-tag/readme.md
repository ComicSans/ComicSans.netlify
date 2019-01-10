# Jekyll Picture Tag

**Easy responsive images for Jekyll.**

It's easy to throw an image on a webpage and call it a day. Doing justice to your users by serving it
efficiently on all screen sizes is tedious and tricky. Tedious, tricky things should be automated; 
Jekyll Picture Tag makes the latter nearly as simple as the former.

It's a liquid tag that adds responsive images to your [Jekyll](http://jekyllrb.com)
static site. Jekyll Picture Tag automatically creates resized, reformatted source images,
is fully configurable, implements sensible defaults, and covers all use cases — including art
direction and resolution switching — with a little YAML configuration and a simple template tag. It
can be configured to work with JavaScript libraries such as [LazyLoad](https://github.com/verlok/lazyload).

## Why use Jekyll Picture Tag?

**Performance:** The fastest sites are static sites. If we're not using responsive images we're
throwing those performance gains away by serving kilobytes of pixels a user will never see.

Image downloading starts before the browser has parsed your CSS and JavaScript; this gets them on the
page *fast*, but it leads to some ridiculously verbose markup.

**Developer Sanity:** Ultimately, to serve responsive images correctly, we must: 

-   Generate, name, and organize the required images (formats \* resolutions, for each source image)
-   Inform the browser about the image itself-- format, size, URI, and the screen sizes where it
    should be used.
-   Inform the browser how large the space for that image on the page will be (which also probably has associated media
    queries).

It's a lot. It's tedious and complicated. Jekyll Picture Tag automates it.

## Strongly Recommended Reading

Jekyll Picture tag is basically a programmatic implementation of the 
[MDN Responsive Images guide](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images).
You should be familiar with these concepts in order to understand how to configure and use it.

## Quick start / Demo

All configuration is optional. Here's the simplest possible use case:

Write this:

`{% picture test.jpg %}`

Get this:

```html
<!-- Line breaks added for readability, the actual markup will not have them. -->
<img 
  src="http://localhost:4000/generated/test-800by450-195f7d.jpg" 
  srcset="
    http://localhost:4000/generated/test-400by225-195f7d.jpg 400w,
    http://localhost:4000/generated/test-600by338-195f7d.jpg 600w,
    http://localhost:4000/generated/test-800by450-195f7d.jpg 800w,
    http://localhost:4000/generated/test-1000by563-195f7d.jpg 1000w"
>
```

**Here's a more complete example.**

With this configuration:

```yml

# _data/picture.yml

media_presets:
  mobile: 'max-width: 600px'

markup_presets:
  default:
    widths: [600, 900, 1200]
    formats: [webp, original]
    sizes: 
      mobile: 80vw
    size: 500px

```

Write this:

`{% picture test.jpg mobile: test2.jpg --alt Alternate Text %}`

Get this:

```html

<!-- Formatted for readability -->
<picture>
  <source 
    sizes="(max-width: 600px) 80vw, 500px"
    media="(max-width: 600px)"
    type="image/webp"
    srcset="http://localhost:4000/generated/test2-600by338-21bb6f.webp 600w,
    http://localhost:4000/generated/test2-900by506-21bb6f.webp 900w,
    http://localhost:4000/generated/test2-1200by675-21bb6f.webp 1200w">

  <source 
    sizes="(max-width: 600px) 80vw, 500px"
    type="image/webp"
    srcset="http://localhost:4000/generated/test-600by338-195f7d.webp 600w,
    http://localhost:4000/generated/test-900by506-195f7d.webp 900w,
    http://localhost:4000/generated/test-1200by675-195f7d.webp 1200w">

  <source 
    sizes="(max-width: 600px) 80vw, 500px"
    media="(max-width: 600px)"
    type="image/jpeg"
    srcset="http://localhost:4000/generated/test2-600by338-21bb6f.jpg 600w,
    http://localhost:4000/generated/test2-900by506-21bb6f.jpg 900w,
    http://localhost:4000/generated/test2-1200by675-21bb6f.jpg 1200w">

  <source 
    sizes="(max-width: 600px) 80vw, 500px"
    type="image/jpeg"
    srcset="http://localhost:4000/generated/test-600by338-195f7d.jpg 600w,
    http://localhost:4000/generated/test-900by506-195f7d.jpg 900w,
    http://localhost:4000/generated/test-1200by675-195f7d.jpg 1200w">

  <img 
    src="http://localhost:4000/generated/test-800by450-195f7d.jpg"
    alt="Alternate Text">
</picture>
```

## Installation

Add `jekyll-picture-tag` to your Gemfile in the `:jekyll_plugins` group.
For now, I don't have push access to RubyGems, meaning you have to point your gemfile at this git repo. 
If you don't, you'll get an old, incompatible version.

```ruby
group :jekyll_plugins do 
  gem 'jekyll-picture-tag', git: 'https://github.com/robwierzbowski/jekyll-picture-tag/'
end 
```

### ImageMagick

Jekyll Picture Tag ultimately relies on [ImageMagick](https://www.imagemagick.org/script/index.php)
for image conversions, so it must be installed on your system. If you want to build webp images, you
will need to install a webp delegate for it as well.

Verify that you have it by entering the following into a terminal:

    $ convert --version

You should see something like this:

    chronos@localhost ~ $ convert --version
    Version: ImageMagick 7.0.8-14 Q16 x86_64 2018-10-31 https://imagemagick.org
    Copyright: © 1999-2018 ImageMagick Studio LLC
    License: https://imagemagick.org/script/license.php
    Features: Cipher DPC HDRI OpenMP 
    Delegates (built-in): bzlib fontconfig freetype jng jp2 jpeg lcms lzma pangocairo png tiff webp xml zlib

Note webp under delegates. This is required if you want to generate webp files.

If you get a 'command not found' error, you'll need to install it.

#### Ubuntu installation:

    sudo apt install imagemagick
    (...)
    sudo apt install webp
    (...)

#### Chromebook installation via [chromebrew](https://github.com/skycocker/chromebrew)

    crew install imagemagick

**Help with instructions for other OSes is greatly appreciated!**

## Usage

`{% picture [preset] img.jpg [media_query_preset: alt.jpg] [attributes] %}`

The tag takes a mix of user input and pointers to configuration settings. Line
breaks and spaces are interchangeable, the following is perfectly acceptable:

```
{% 
  picture my-preset
    img.jpg 
    mobile: alt.jpg 
    --alt Alt Text
    --picture class="stumpy"
%}
```

Note the tag parser looks for some whitespace followed by `'--'`. If you need to set HTML attribute
values which begin with `'--'`, either set them first (`class="--my-class"`) or using `_data/picture.yml`
settings. `class="some-class --some-other-class"` will break things.

#### picture

Tells Liquid this is a Jekyll Picture Tag.

#### preset

Optionally specify a markup [preset](#markup_presets) to use, or leave blank for the `default` preset.

#### img.jpg

The base image that will be resized for your picture sources. Can be a jpeg, png, webp, or gif.

#### media_query_preset: alt.jpg

Optionally specify alternate base images for given [media queries](media_presets) (specified in \_data/picture.yml).
This is one of of picture's strongest features, often referred to as the [art direction use
case](http://usecases.responsiveimages.org/#art-direction). 

Give your images in order of ascending specificity (The first image is the most general). They will
be provided to the browser in reverse order, and it will select the first one with a media query
that evaluates true.

#### attributes

Optionally specify any number of HTML attributes. These will be merged with any attributes you've
set in a preset.

`--(element)` will apply those attributes to the given element. Your options are picture, img, or
source.

`--alt` is a shortcut for `--img alt="..."`

`--parent` will be applied to the outermost element; useful when using the
`auto` output format.

Example: 

`--picture class="killer" --alt Alternate Text --source data-volume="11"`

The old syntax is to just dump them at the end:

`{% picture example.jpg alt="alt text" class="super-duper" %}`

This will continue to work. For backwards compatibility, behavior of previous versions is
maintained: all attributes specified this way are applied to the img tag. 

### Configuration

Jekyll Picture Tag stores global settings under the `picture` key in your \_config.yml, and presets
under \_data/picture.yml (to avoid cluttering config.yml)

**Example settings under \_config.yml**

```yml
picture: 
  source: "assets/images/_fullsize"
  output: "generated" 
  suppress_warnings: false
```

#### source

To make writing tags easier you can specify a source directory for your assets. Base images in the
tag will be relative to the `source` directory. 

For example, if `source` is set to `assets/images/_fullsize`, the tag 
`{% picture enishte/portrait.jpg alt="An unsual picture" %}` will look for a file at
`assets/images/_fullsize/enishte/portrait.jpg`.

Default: Jekyll source directory.

#### output

Jekyll Picture Tag generates resized images to the `output` directory in your compiled site. The
organization of your `source` directory is maintained in the output directory. 

Default: `{compiled Jekyll site}/generated`. `{compiled Jekyll site}` means `_site`, unless you've
changed it.

#### suppress_warnings

Jekyll Picture Tag will warn you in a few different scenarios, such as when your
base image is smaller than one of the sizes in your preset. (Note that Jekyll
Picture Tag will never resize an image to be larger than its source). Set this
value to `true`, and these warnings will not be shown.

Default: `false`

**Example \_data/picture.yml**

All settings are optional, moderately sensible defaults have been implemented. A template can be
found in the 
[example data file](https://github.com/robwierzbowski/jekyll-picture-tag/blob/refactor/examples/_data/picture.yml)
in the examples directory.

    media_presets:
      wide_desktop: 'min-width: 1801px'
      desktop: 'max-width: 1800px'
      wide_tablet: 'max-width: 1200px'
      tablet: 'max-width: 900px'
      mobile: 'max-width: 600px'

    markup_presets:
      default:
        markup: auto
        formats: [webp, original]
        widths: [200, 400, 800, 1600]
        media_widths: 
          mobile: [200, 400, 600] 
          tablet: [400, 600, 800]
        size: 800px
        sizes: 
          mobile: 100vw
          desktop: 60vw
        fallback_width: 800
        fallback_format: original
        attributes:
          picture: 'class="awesome" data-volume="11"'
          img: 'class="some-other-class"'

      icon:
        base-width: 20
        pixel_ratios: [1, 1.5, 2]

      lazy:
        markup: data_auto
        formats: [webp, original]
        widths: [200, 400, 600, 800]
        attributes: 
          img: class="lazy"

#### media_presets

  Keys are names by which you can refer to the media queries supplied as their respective values.
  These are used for specifying alternate source images in your liquid tag, and for building the
  'sizes' attribute within your presets. Quotes are required around them, because yml gets confused
  by free colons.

#### markup_presets

  These are the 'presets' from previous versions, with different structure. Each entry is a
  pre-defined collection of settings to build a given chunk of HTML and its respective images.

  The `default` preset will be used if none is specified in the liquid tag. A preset name can't
  contain the `.`, `:`, or `/` characters.

#### markup

This defines what format the generated HTML will take. 

-   `picture`: output markup based on the `<picture>` element. 
-   `img`: output a single `img` tag with a `srcset` entry.
-   `auto`: Supply an img tag when you have only one srcset, otherwise supply a picture tag.
-   `data_picture`, `data_img`, `data_auto`: Analogous to their counterparts,
    but instead of `src`, `srcset`, and `sizes`, you get `data-src`, `data-srcset`, and
    `data-sizes`. This allows you to use javascript for things like [lazy
    loading](https://github.com/verlok/lazyload)

Default: `auto`

#### formats

Array (yml sequence) of the image formats you'd like to generate, in decreasing order
of preference.  Browsers will render the first format they find and understand, so if you put jpg
before webp, your webp images will never be used.  `original` does what you'd expect. To supply
webp, you must install an imagemagick webp delegate.

Default: `original`

#### fallback_width, fallback_format

Properties of the fallback image, format and width. 

Default: `original` and `800`

#### widths

For use when you want a size-based srcset (example: `srcset="img.jpg 800w, img2.jpg
1600w"`). Array of image widths to generate, in pixels. 

Default: `[400, 600, 800, 1000]`

#### media_widths

If you are using art direction, there is no sense in generating desktop-size files for your
mobile image. You can specify sets of widths to associate with given media queries. If not
specified, will use `widths` setting.

#### sizes

Conditional sizes; these will be used to construct the `sizes=` HTML attribute telling the browser
how wide your image will be when a given media query is true.

The same sizes attribute is used for every source tag in a given picture tag. This causes some
redundant markup, specifying sizes for situations when an image will never be rendered, but the
simplicity of configuration is worth a few extra bytes.

#### size

Unconditional image width to give the browser (by way of the html sizes attribute), to be supplied
either alone or after all conditional sizes.

#### base_width

For use when you want a multiplier based srcset (example: `srcset="img.jpg 1x, img2.jpg 2x"`). This
base width sets how wide the 1x image should be.

#### pixel_ratios

Array of images to construct, given in multiples of the base width.

#### attributes

Additional HTML attributes you would like to add. An attribute set in a tag will override the same
attribute set in a preset.

The same arguments are available here as in the liquid tag; element names, `alt:`, and `parent:`.
They follow the format of (element name): 'attribute="value" attribute2="value2"'. (Unescaped double
quotes cause problems with yml, so surround the entire string with single quotes.)

## Liquid variables

You can use liquid variables in a picture tag:

`html {% picture {{ post.featured_image }} --alt Our Project %}`

## Lazy Loading, and other javascript related tomfoolery

Use one of the `data_` output formats and something like
[LazyLoad](https://github.com/verlok/lazyload). The 'lazy' preset in the example config will work.
New formats are simple to add, especially if all that changes are attribute names. Submit a feature
request.

## PictureFill

[Picturefill](http://scottjehl.github.io/picturefill/) version 3 no longer requires special markup.
Standard outputs should be compatible.

## Managing Generated Images

Jekyll Picture Tag creates resized versions of your images when you build the site. It uses a smart
caching system to speed up site compilation, and re-uses images as much as possible. Filenames
take the following format:

`(original filename without extension)_(width)by(height)_(source hash).(format)`

Source hash is the first 5 characters of an md5 checksum of the source image.

Try to use a base image that is larger than the largest resized image you need. Jekyll Picture Tag
will warn you if a base image is too small, and won't upscale images.

By specifying a `source` directory that is ignored by Jekyll you can prevent huge base images from
being copied to the compiled site. For example, `source: assets/images/_fullsize` and `output:
generated` will result in a compiled site that contains resized images but not the originals.

The `output` directory is never deleted by Jekyll. You may want to manually clean it every once in a
while to remove unused images.

Responsive images are a good first step to improve performance, but you should still use a build
process to optimize site assets before deploying. If you're a cool kid, take a look at
[Yeoman](http://yeoman.io/) and
[generator-jekyllrb](https://github.com/robwierzbowski/generator-jekyllrb).

## Contribute

Report bugs and feature proposals in the 
[Github issue tracker](https://github.com/robwierzbowski/jekyll-picture-tag/issues).

Pull requests are encouraged. With a few exceptions, this plugin is written to follow the Rubocop
default settings.

## Release History
**1.0.0**, Nov 27, 2018: Rewrite from the ground up. See 
[migration.md](https://github.com/robwierzbowski/jekyll-picture-tag/blob/master/migration.md).

0.2.2, Aug 2, 2013: Bugfixes.  0.2.1, July 17, 2013: Refactor again, add Liquid parsing.  0.2.0,
July 14, 2013: Rewrite code base, bring in line with Jekyll Image Tag.  0.1.1, July 5, 2013: Quick
round of code improvements.  0.1.0, July 5, 2013: Initial release.

## License

[BSD-NEW](http://en.wikipedia.org/wiki/BSD_License)

[![Bitdeli
Badge](https://d2weczhvl823v0.cloudfront.net/robwierzbowski/jekyll-picture-tag/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
