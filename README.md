# Twemoji

[![Gem Version](http://img.shields.io/gem/v/twemoji.svg)][gem]
[![Build Status](https://travis-ci.org/jollygoodcode/twemoji.svg)][travis]
[![Inline docs](http://inch-ci.org/github/jollygoodcode/twemoji.svg?branch=master)][inch-doc]

[gem]: https://rubygems.org/gems/twemoji
[travis]: https://travis-ci.org/jollygoodcode/twemoji
[inch-doc]: http://inch-ci.org/github/jollygoodcode/twemoji

Twitter Emoji has a official JavaScript implementation of [twemoji](https://github.com/twitter/twemoji). This RubyGem Twemoji is a minimum implementation in Ruby, does not implement all its features.

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

@bramswenson has put an effeort to support Ruby 1.9.3, please use [his forked branch](https://github.com/bramswenson/twemoji/tree/ruby-1.9.3):

```ruby
gem "twemoji", github: "bramswenson/twemoji", branch: "ruby-1.9.3"
```

## Integration

- [Integration with html-pipeline](https://github.com/jollygoodcode/twemoji/wiki/Integrate-with-html-pipeline)

## Usage

### API

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
> Twemoji.find_by_unicode("😍")
=> ":heart_eyes:"

> Twemoji.find_by_unicode("\u{1f60d}")
=> ":heart_eyes:"
```

#### `Twemoji.find_by` text, code or unicode

```ruby
> Twemoji.find_by(text: ":heart_eyes:")
=> 1f60d

> Twemoji.find_by(code: "1f60d")
=> :heart_eyes:

> Twemoji.find_by(unicode: "😍")
=> :heart_eyes:

> Twemoji.find_by(unicode: "u\{1f60d}")
=> :heart_eyes:
```

#### `Twemoji.parse`

```ruby
> Twemoji.parse "I like chocolate :heart_eyes:!"
=> 'I like chololate <img class="emoji" draggable="false" alt=":heart_eyes:" src="https://twemoji.maxcdn.com/16x16/1f60d.png">'
```

##### options

##### asset_root

Default assets root url, by default will be `https://twemoji.maxcdn.com/`:

```ruby
> Twemoji.parse 'I like chocolate :heart_eyes:!', asset_root: "foocdn.com"
=> 'I like chololate <img class="emoji" draggable="false" alt=":heart_eyes:" src="https://foocdn.com/16x16/1f60d.png">'
```

##### file_ext

Default assets file extensions, by default `.png`.

```ruby
> Twemoji.parse 'I like chocolate :heart_eyes:!', file_ext: ".svg"
=> 'I like chololate <img class="emoji" draggable="false" alt=":heart_eyes:" src="https://twemoji.maxcdn.com/svg/1f60d.svg">'
```

##### image_size

Default assets/folder size, by default `"16x16"`. Available via Twitter CDN: `16`, `36`, `72`.

```ruby
> Twemoji.parse 'I like chocolate :heart_eyes:!', image_size: "72x72"
=> 'I like chololate <img class="emoji" draggable="false" alt=":heart_eyes:" src="https://twemoji.maxcdn.com/72x72/1f60d.png">'
```

##### class_name

Default img css class name, by default `"emoji"`.

```ruby
> Twemoji.parse 'I like chocolate :heart_eyes:!', class_name: "superemoji"
=> 'I like chololate <img class="superemoji" draggable="false" alt=":heart_eyes:" src="https://twemoji.maxcdn.com/16x16/1f60d.png">'
```

##### img_attr

```ruby
Twemoji.parse("I like chocolate :heart_eyes:!", class_name: 'twemoji', img_attr: "style='height: 1.3em;'")
=> "I like chocolate <img class='twemoji' draggable='false' title=':heart_eyes:' alt=':heart_eyes:' style='height: 1.3em;' src='https://twemoji.maxcdn.com/16x16/1f60d.png'>!"
```

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
