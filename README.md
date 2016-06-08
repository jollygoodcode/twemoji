# Twemoji

[![Gem Version](https://badge.fury.io/rb/twemoji.svg)](https://badge.fury.io/rb/twemoji)
[![Build Status](https://travis-ci.org/jollygoodcode/twemoji.svg)][travis]
[![Inline docs](http://inch-ci.org/github/jollygoodcode/twemoji.svg?branch=master)][inch-doc]

[gem]: https://rubygems.org/gems/twemoji
[travis]: https://travis-ci.org/jollygoodcode/twemoji
[inch-doc]: http://inch-ci.org/github/jollygoodcode/twemoji

Twitter [opensourced Twitter Emoji](http://twitter.github.io/twemoji/) and the official JavaScript implementation is available at [twemoji](https://github.com/twitter/twemoji).

This RubyGem `twemoji` is a minimum implementation of Twitter Emoji in Ruby so that you can haz emoji in your Ruby/Rails apps too!

__Note:__ This gem might not implement all the features available in the JavaScript implementation.

## Twemoji Gem and twemoji.js versions

- Twemoji Gem 3.x supports twemoji.js V2 (1661 emojis)
- Twemoji Gem 2.x supports twemoji.js V1 (874 emojis)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "twemoji"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twemoji

## Integration

- [Integration with `HTML::Pipeline`](https://github.com/jollygoodcode/twemoji/wiki/Integrate-with-HTML%3A%3APipeline)

## Rails Helper

`$ touch app/helpers/emoji_helper.rb`

```ruby
module EmojiHelper
  def emojify(content, **options)
    Twemoji.parse(h(content), options).html_safe if content.present?
  end
end
```

In your ERb view:

```erb
<%= emojify "I like chocolate :heart_eyes:!", image_size: "36x36" %>
```

will render

```
I like chocolate <img class="emoji" draggable="false" title=":heart_eyes:" alt="😍" src="https://twemoji.maxcdn.com/2/36x36/1f60d.png">!
```

More options could be passed in, please see [Twemoji.parse options](https://github.com/jollygoodcode/twemoji#twemojiparse-options) for more details.

## Usage

### API

#### `Twemoji.find_by` text or code or unicode

```ruby
> Twemoji.find_by(text: ":heart_eyes:")
=> "1f60d"

> Twemoji.find_by(code: "1f60d")
=> ":heart_eyes:"

> Twemoji.find_by(unicode: "😍")
=> ":heart_eyes:"

> Twemoji.find_by(unicode: "\u{1f60d}")
=> ":heart_eyes:"
```

#### `Twemoji.find_by_text`

```ruby
> Twemoji.find_by_text(":heart_eyes:")
=> "1f60d"
```

#### `Twemoji.find_by_code`

```ruby
> Twemoji.find_by_code("1f60d")
=> ":heart_eyes:"
```

#### `Twemoji.find_by_unicode`

```ruby
> Twemoji.find_by(unicode: "😍")
=> ":heart_eyes:"
```

#### `Twemoji.render_unicode`

```ruby
> Twemoji.render_unicode ":heart_eyes:"
=> "😍"

> Twemoji.render_unicode "1f60d"
=> "😍"
```

#### `Twemoji.parse`

```ruby
> Twemoji.parse "I like chocolate :heart_eyes:!"
=> "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://twemoji.maxcdn.com/2/72x72/1f60d.png'>!"
```

##### `Twemoji.parse` options

##### `asset_root`

Default assets root url. Defaults to `https://twemoji.maxcdn.com/2/`:

```ruby
> Twemoji.parse 'I like chocolate :heart_eyes:!', asset_root: "foocdn.com"
=> "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt='😍' src='foocdn.com/72x72/1f60d.png'>!"
```

##### `file_ext`

Default assets file extensions. Defaults to `.png`.

```ruby
> Twemoji.parse 'I like chocolate :heart_eyes:!', file_ext: ".svg"
=> "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://twemoji.maxcdn.com/2/svg/1f60d.svg'>!"
```

##### `class_name`

Default image CSS class name. Defaults to `"emoji"`.

```ruby
> Twemoji.parse 'I like chocolate :heart_eyes:!', class_name: "superemoji"
=> "I like chocolate <img class='superemoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://twemoji.maxcdn.com/2/72x72/1f60d.png'>!"
```

##### `img_attrs`

List of image attributes for the `img` tag. Optional.

```ruby
> Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji', img_attrs: { style: "height: 1.3em;" })
=> "I like chocolate <img class='twemoji' draggable='false' title=':heart_eyes:' alt='😍' style='height: 1.3em;' src='https://twemoji.maxcdn.com/2/72x72/1f60d.png'>!"
```

attribute value can apply proc-like object, remove `:` from title attribute:

```ruby
> no_colons = ->(name) { name.gsub(":", "") }

> Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji', img_attrs: { title: no_colons })
=> "I like chocolate <img class='twemoji' draggable='false' title='heart_eyes' alt='😍' src='https://twemoji.maxcdn.com/2/72x72/1f60d.png'>!"
```

#### `Twemoji.emoji_pattern`

```ruby
> Twemoji.emoji_pattern
=> /(:smile:|:laughing:| ... |:womens:|:x:|:zero:)/
```

#### JSON for your front-end

Please take a look at [Twemoji::PNG](lib/twemoji/png.rb) and [Twemoji::SVG](lib/twemoji/svg.rb) and use `to_json` yourself.

## Configuration

`Twemoji.parse` options can be given in configure block, default values are:

```ruby
Twemoji.configure do |config|
  config.asset_root = "https://twemoji.maxcdn.com/2"
  config.file_ext   = ".svg"
  config.class_name = "emoji"
  config.img_attrs  = {}
end
```

Specify additional img attributes like so:

```ruby
config.img_attrs  = { style: "height: 1.3em;" }
```

## Tips (from twitter/twemoji)

### Inline Styles

If you'd like to size the emoji according to the surrounding text, you can add the following CSS to your stylesheet:

```css
img.emoji {
  height: 1em;
  width: 1em;
  margin: 0 .05em 0 .1em;
  vertical-align: -0.1em;
}
```

This will make sure emoji derive their width and height from the font-size of the text they're shown with. It also adds just a little bit of space before and after each emoji, and pulls them upwards a little bit for better optical alignment.

### UTF-8 Character Set

To properly support emoji, the document character must be set to UTF-8. This can done by including the following meta tag in the document <head>

```html
<meta charset="utf-8">
```

## Attribution Requirements

**IMPORTANT:** Please follow the [Attribution Requirements](https://github.com/twitter/twemoji#attribution-requirements) as stated on the official Twemoji (JS) repo.

## Contributing

Please see the [CONTRIBUTING.md](/CONTRIBUTING.md) file.

## Credits

A huge THANK YOU to all our [contributors](https://github.com/jollygoodcode/twemoji/graphs/contributors)! :heart:

The emoji keywords are from [jollygoodcode/emoji-keywords](https://github.com/jollygoodcode/emoji-keywords).

## License

Please see the [LICENSE.md](/LICENSE.md) file.

## Maintained by Jolly Good Code

[![Jolly Good Code](https://cloud.githubusercontent.com/assets/1000669/9362336/72f9c406-46d2-11e5-94de-5060e83fcf83.jpg)](http://www.jollygoodcode.com)

We specialise in rapid development of high quality MVPs. [Hire us](http://www.jollygoodcode.com/#get-in-touch) to turn your product idea into reality.
