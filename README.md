# Twemoji

[![Gem Version](http://img.shields.io/gem/v/twemoji.svg)][gem]
[![Build Status](https://travis-ci.org/jollygoodcode/twemoji.svg)][travis]
[![Inline docs](http://inch-ci.org/github/jollygoodcode/twemoji.svg?branch=master)][inch-doc]

[gem]: https://rubygems.org/gems/twemoji
[travis]: https://travis-ci.org/jollygoodcode/twemoji
[inch-doc]: http://inch-ci.org/github/jollygoodcode/twemoji

Twitter [opensourced Twitter Emoji](http://twitter.github.io/twemoji/) and the official JavaScript implementation is available at [twemoji](https://github.com/twitter/twemoji).

This RubyGem `twemoji` is a minimum implementation of Twitter Emoji in Ruby so that you can haz emoji in your Ruby/Rails apps too!

__Note:__ This gem might not implement all the features available in the JavaScript implementation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "twemoji"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install twemoji

### Ruby 1.9.3 Support

@bramswenson has put in effort to support Ruby 1.9.3, please use [his forked branch](https://github.com/bramswenson/twemoji/tree/ruby-1.9.3):

```ruby
gem "twemoji", github: "bramswenson/twemoji", branch: "ruby-1.9.3"
```

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
I like chocolate <img class="emoji" draggable="false" title=":heart_eyes:" alt="😍" src="https://twemoji.maxcdn.com/36x36/1f60d.png">!
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
=> "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://twemoji.maxcdn.com/16x16/1f60d.png'>!"
```

##### `Twemoji.parse` options

##### `asset_root`

Default assets root url. Defaults to `https://twemoji.maxcdn.com/`:

```ruby
> Twemoji.parse 'I like chocolate :heart_eyes:!', asset_root: "foocdn.com"
=> "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt='😍' src='foocdn.com/16x16/1f60d.png'>!"
```

##### `file_ext`

Default assets file extensions. Defaults to `.png`.

```ruby
> Twemoji.parse 'I like chocolate :heart_eyes:!', file_ext: ".svg"
=> "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://twemoji.maxcdn.com/svg/1f60d.svg'>!"
```

##### `image_size`

Default assets/folder size. Defaults to `"16x16"`.

Sizes available via Twitter CDN: `16`, `36`, `72`.

```ruby
> Twemoji.parse 'I like chocolate :heart_eyes:!', image_size: "72x72"
=> "I like chocolate <img class='emoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://twemoji.maxcdn.com/72x72/1f60d.png'>!"
```

##### `class_name`

Default image CSS class name. Defaults to `"emoji"`.

```ruby
> Twemoji.parse 'I like chocolate :heart_eyes:!', class_name: "superemoji"
=> "I like chocolate <img class='superemoji' draggable='false' title=':heart_eyes:' alt='😍' src='https://twemoji.maxcdn.com/16x16/1f60d.png'>!"
```

##### `img_attr`

List of image attributes for the `img` tag. Optional.

```ruby
> Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji', img_attr: "style='height: 1.3em;'")
=> "I like chocolate <img class='twemoji' draggable='false' title=':heart_eyes:' alt='😍' style='height: 1.3em;' src='https://twemoji.maxcdn.com/16x16/1f60d.png'>!"
```

#### `Twemoji.emoji_pattern`

```ruby
> Twemoji.emoji_pattern
=> /(:smile:|:laughing:| ... |:womens:|:x:|:zero:)/
```

## Configuration

`Twemoji.parse` options can be given in configure block:

```ruby
Twemoji.configure do |config|
  config.asset_root = "https://twemoji.awesomecdn.com/"
  config.file_ext   = ".svg"
  config.image_size = nil # only png need to set size
  config.class_name = "twemoji"
  config.img_attr   = "style='height: 1.3em;'"
end
```

## Attribution Requirements

Please follow the [Attribution Requirements](https://github.com/twitter/twemoji#attribution-requirements) as stated on the official Twemoji (JS) repo.

## Contributing

1. Fork it ( https://github.com/jollygoodcode/twemoji/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Credits

A huge THANK YOU to all our [contributors] (https://github.com/jollygoodcode/twemoji/graphs/contributors)! :heart:

This project is maintained by [Jolly Good Code](http://www.jollygoodcode.com).

## License

MIT License. See [LICENSE](LICENSE) for details.
