# Twemoji

[![Gem Version](https://badge.fury.io/rb/twemoji.svg)](https://badge.fury.io/rb/twemoji)
[![Build Status](https://travis-ci.org/jollygoodcode/twemoji.svg)][travis]
[![Inline docs](http://inch-ci.org/github/jollygoodcode/twemoji.svg?branch=master)][inch-doc]

[gem]: https://rubygems.org/gems/twemoji
[travis]: https://travis-ci.org/jollygoodcode/twemoji
[inch-doc]: http://inch-ci.org/github/jollygoodcode/twemoji

Twitter [opensourced Twitter Emoji](http://twitter.github.io/twemoji/) and the official JavaScript implementation is available at [twemoji](https://github.com/twitter/twemoji).

This RubyGem `twemoji` is a minimum implementation of Twitter Emoji in Ruby so that you can use emoji in your Ruby/Rails apps too!

## About this fork

It looks like the original Twemoji gem isn't maintained – the latest version contains only 1.6K emojies from 3.6K emojies present in the latest Twemoji version.

This fork:

* fixes a broken CDN URL (Twemojies are hosted on [jsdelivr.com/](https://www.jsdelivr.com/) now :heart:)
* imports the latest emojies set (with backwards compatibility)
* adds the necessary tooling to easily import future editions

### How to import the latest Twemoji set

**Step 1**. Change the CDN URL (`Twemoji::Configuration::DEFAULT_ASSET_ROOT`) constant.

**Step 2**. Run the tooling script that downloads the latest [unicode.org](https://unicode.org/Public/emoji/latest/emoji-test.txt) official emoji list, validates which emojies are present on CDN and prepares unicode-emoji name maps for the gem.

```bash
bundle install

bundle exec ruby tooling/import_latest_emojies.rb
```

**Step 3**. PROFIT :beers:

## Twemoji Gem and twemoji.js versions

- Twemoji Gem 4.x supports Twemoji v14 (3245 emojis)
- Twemoji Gem 3.x supports twemoji.js V2 (1661 emojis) [Preview](https://jollygoodcode.github.io/twemoji/)
- Twemoji Gem 2.x supports twemoji.js V1 (874 emojis) [Preview](http://jollygoodcode.github.io/twemoji/v1/)

*Preview pages' Images is CC-BY 4.0 by [Twitter/Twemoji](https://github.com/twitter/twemoji).*

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

## Twemoji and Rails

- [Checkout this tutorial: Twemoji in Rails](https://github.com/jollygoodcode/jollygoodcode.github.io/issues/18)

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
<%= emojify "I like chocolate :heart_eyes:!" %>
```

will render

```
I like chocolate <img class="emoji" draggable="false" title=":heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/1f60d.png">!
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

Parses for both name tokens (e.g. :heart_eyes:) or unicode values (e.g. `\u1f60d`).

Parsing by name token:

```ruby
> Twemoji.parse "I like chocolate :heart_eyes:!"
=> 'I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="emoji">!'
```

Parsing by name unicode values:

```ruby
> Twemoji.parse "I like chocolate 😍!"
=> 'I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="emoji">!'
```

Parsing by both name and unicode:

```ruby
> Twemoji.parse ":cookie: 🎂"
=> '<img draggable="false" title=":cookie:" alt="🍪" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f36a.svg" class="emoji"> <img draggable="false" title=":birthday:" alt="🎂" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f382.svg" class="emoji">'
```

##### `Twemoji.parse` options

##### `asset_root`

Default assets root url. Defaults to `https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/`:

```ruby
> Twemoji.parse "I like chocolate :heart_eyes:!", asset_root: "foocdn.com"
=> 'I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="foocdn.com/svg/1f60d.svg" class="emoji">!'
```

##### `file_ext`

Default assets file extensions. Defaults to `svg`.

Can change to `"png"`:

```ruby
> Twemoji.parse 'I like chocolate :heart_eyes:!', file_ext: "png"
=> 'I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/72x72/1f60d.png" class="emoji">!'
```

##### `class_name`

Default image CSS class name. Defaults to `"emoji"`.

```ruby
> Twemoji.parse "I like chocolate :heart_eyes:!", class_name: "superemoji"
=> 'I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="superemoji">!'
```

##### `img_attrs`

List of image attributes for the `img` tag. Optional.

```ruby
> Twemoji.parse "I like chocolate :heart_eyes:!", class_name: "twemoji", img_attrs: { style: "height: 1.3em;" }
=> 'I like chocolate <img draggable="false" title=":heart_eyes:" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="twemoji" style="height: 1.3em;">!'
```

attribute value can apply proc-like object, remove `:` from title attribute:

```ruby
> no_colons = ->(name) { name.gsub(":", "") }

> Twemoji.parse "I like chocolate :heart_eyes:!", class_name: "twemoji", img_attrs: { title: no_colons }
=> 'I like chocolate <img draggable="false" title="heart_eyes" alt="😍" src="https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets/svg/1f60d.svg" class="twemoji">!'
```

#### `Twemoji.emoji_pattern`

```ruby
> Twemoji.emoji_pattern
=> /(:mahjong:|:black_joker:| ... |:registered_sign:|:shibuya:)/
```

#### `Twemoji.emoji_pattern_unicode`

```ruby
> Twemoji.emoji_pattern_unicode
```

#### `Twemoji.emoji_pattern_all` = `emoji_pattern` + `emoji_pattern_unicode`

```ruby
> Twemoji.emoji_pattern_all
```

#### JSON for your front-end

We prepare two constants: [Twemoji.png](lib/twemoji/png.rb) and [Twemoji.svg](lib/twemoji/svg.rb) (**not loaded by default**), you need to require them to use:

```ruby
require "twemoji/png" # If you want to use Twemoji.png
require "twemoji/svg" # If you want to use Twemoji.svg
```

Or require at `Gemfile`:

```ruby
# Require the one you need, require Twemoji::PNG
gem "twemoji", require: "twemoji/png"

# Or Twemoji::SVG
gem "twemoji", require: "twemoji/svg"

# Or both
gem "twemoji", require: ["twemoji/png", "twemoji/svg"]
```

Then you can do `to_json` to feed your front-end.

You can also make custom format by leverage `Twemoji.codes`:

```html+erb
# emojis.json.erb
<%= Twemoji.codes.collect do |code, _|
  Hash(
    value: code,
    html: content_tag(:span, Twemoji.parse(code).html_safe + " #{code}" )
  )
end.to_json.html_safe %>
```

## Configuration

`Twemoji.parse` options can be given in configure block, default values are:

```ruby
Twemoji.configure do |config|
  config.asset_root = "https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.2/assets"
  config.file_ext   = "svg"
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

**IMPORTANT:** Please follow the [Attribution Requirements](https://github.com/twitter/twemoji#attribution-requirements) as stated on the official Twemoji (JavaScript) repo.

## Contributing

Please see the [CONTRIBUTING.md](/CONTRIBUTING.md) file.

## Credits

A huge THANK YOU to all our [contributors](https://github.com/jollygoodcode/twemoji/graphs/contributors)! :heart:

The emoji keywords are from [jollygoodcode/emoji-keywords](https://github.com/jollygoodcode/emoji-keywords).

## Guidelines

This project subscribes to the [Moya Contributors Guidelines](https://github.com/Moya/contributors)
which TLDR: means we give out push access easily and often.

## License

Please see the [LICENSE.md](/LICENSE.md) file.

## Maintained by Jolly Good Code

[![Jolly Good Code](https://cloud.githubusercontent.com/assets/1000669/9362336/72f9c406-46d2-11e5-94de-5060e83fcf83.jpg)](http://www.jollygoodcode.com)

We specialise in rapid development of high quality MVPs. [Hire us](http://www.jollygoodcode.com/#get-in-touch) to turn your product idea into reality.
