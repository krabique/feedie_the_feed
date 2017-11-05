[![Build Status](https://travis-ci.org/krabique48/feedie_the_feed.svg?branch=master)](https://travis-ci.org/krabique48/feedie_the_feed) [![Gem Version](https://badge.fury.io/rb/feedie_the_feed.svg)](https://badge.fury.io/rb/feedie_the_feed) [![Dependency Status](https://gemnasium.com/badges/github.com/krabique48/feedie_the_feed.svg)](https://gemnasium.com/github.com/krabique48/feedie_the_feed) [![Maintainability](https://api.codeclimate.com/v1/badges/2b6e9817b3a7664751a5/maintainability)](https://codeclimate.com/github/krabique48/feedie_the_feed/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/2b6e9817b3a7664751a5/test_coverage)](https://codeclimate.com/github/krabique48/feedie_the_feed/test_coverage) 

# Feedie The Feed

Hi! My name is Feedie The Feed. I'm a Ruby gem that enables you to aggregate RSS and Facebook pages feed with one entry point, wooop! Just feed me the link and I'll go get them for you, master! Rawr!

## Technology

I should work on Ruby 2.2 and over. I'm built with great help from 
these cool gems:
* [feedjira](https://github.com/feedjira/feedjira) - for RSS feed
* [koala](https://github.com/arsduo/koala) - for the Facebook API
* [public_suffix](https://github.com/weppos/publicsuffix-ruby) - for parsing the links
* [nesty](https://github.com/skorks/nesty) - for cute nested exceptions

## Getting Started

### Installing

You can just

```
gem install feedie_the_feed
```

and you're good to go! Although it may contain a slightly older version, so you can clone me (oh the 21st century), if you feel adventurous!

```
git clone git@github.com:krabique48/feedie_the_feed.git
cd feedie_the_feed
bundle install
```

### Running the tests

Just run rake and watch it go green for RSpec and RuboCop!

```
bundle exec rake
```

### Documentation

Have my bro YARD generate the documentation for you

```
yard doc
```

Or just visit http://www.rubydoc.info/gems/feedie_the_feed/ for that matter.

## How to use

### try_me.rb

You can check `try_me.rb` out, it's quite self-explanatory.

### RSS

Very simple, create FeedieTheFeed::FeedGrabber object and use it's get method with a URL as a parameter:

```
@feed_grabber = FeedieTheFeed::FeedGrabber.new
feed = @feed_grabber.get(
  'https://raw.githubusercontent.com/krabique48/' \
  'feedie_the_feed/master/rss_test_sample'
)
```

(return format is explained below)

### Facebook

To use the gem with Facebook you'll have to use your Facebook AppID and Facebook secret key.The simplest way to provide those is to just have them in your environment variables as FACEBOOK_APPID and FACEBOOK_SECRET. This way, all you have to do is create a new instance of the FeedieTheFeed::FeedGrabber class and call it's get method with a URL to a Facebook page as a parameter.

```
@feed_grabber = FeedieTheFeed::FeedGrabber.new
@feed_grabber.get('https://www.facebook.com/ruby.programming')
```

### Module method

You can also do this, without explicitly creating an object, as a shortcut.

```
FeedieTheFeed.get('https://www.facebook.com/ruby.programming')
```

It acts just like as if you have created a FeedieTheFeed::FeedGrabber instance, and called it's get instance method.

#### Facebook credentials priorities

Facebook AppID and secret key follow a priority rule:

```
get method parameters > object values > environment variables
```

So, you can also provide the Facebook credentials as parameters in the get method:

```
@feed_grabber = FeedieTheFeed::FeedGrabber.new
@feed_grabber.get(
  'https://www.facebook.com/ruby.programming',
  facebook_appid: '123',
  facebook_secret: '123'
)
```

Or during object creation:

```
@feed_grabber = FeedieTheFeed::FeedGrabber.new(
  facebook_appid: '123',
  facebook_secret: '123'
)
@feed_grabber.get('https://www.facebook.com/ruby.programming')
```

#### Facebook posts limit

You can also set the amount of posts you want to get, similarly to Facebook credentials (it also follows the same priority rule):

```
@feed_grabber = FeedieTheFeed::FeedGrabber.new(facebook_posts_limit: 50)
```

or

```
@feed_grabber.get(some_url, facebook_posts_limit: 50)
```

and if you don't provide it at all, it shall default to 10.

### Output format

So the `get` method returns an **array of hashes**, where each hash is either a Facebook page post or an RSS entry.

#### Hash keys

##### Facebook

Facebook hashes would always have these keys:

```
'entry_id'
'url'
'published'
```

plus some additional ones that may not always be there, due to the nature of Facebook posts:

```
'title'
'summary'
'image'
```

`'title'`, if not provided, will be automatically generated based on `'summary'`, and will not exceed 80 characters (exactly like RoR truncate(80) method). For example,

```
summary: The Grand Finals of the #ManilaMasters will start in less than an hour. Newbee or Evil Geniuses, who are you rooting for?
```

will turn to

```
title: The Grand Finals of the #ManilaMasters will start is less than an hour...
```

##### RSS

With RSS, the only two keys that would be there no matter what are `entry_id` and `url`, due to the nature of RSS. Although, most of the time, some other keys will also be present:

```
'entry_id'
'title'
'summary'
'url'
'published'
'image'
```

### Other utility methods

#### fb_appid_and_secret_key(facebook_appid, facebook_secret)

`fb_appid_and_secret_key(facebook_appid, facebook_secret)` is used to set the Facebook credentials for the object.

#### reset_fb_appid_and_secret_key!

`reset_fb_appid_and_secret_key!` is used to reset the Facebook credentials for the object.

#### fb_posts_limit(limit)

`fb_posts_limit(limit)` is used to set the object's Facebook posts limit (should be an integer from 1 to 100).

#### reset_fb_posts_limit!

`reset_fb_posts_limit!` is used to reset the object's Facebook posts limit.

## Authors

* **Oleg Larkin** - *Initial work* - [krabique48](https://github.com/krabique48) (krabique48@gmail.com)
