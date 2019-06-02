# CHANGELOG

## Unreleased

- Introduced `Twemoji::Utils::Unicode#unpack` [#51](https://github.com/jollygoodcode/twemoji/pull/51)
- Do not set attribute on generated element if not specified [#44](https://github.com/jollygoodcode/twemoji/pull/49)

## 3.1.4 - 2017.07.22

- Fixes woman skin 6 emoji [#44](https://github.com/jollygoodcode/twemoji/pull/44)

## 3.1.3 - 2017.07.22

- Fixes name of kiss emoji [#42](https://github.com/jollygoodcode/twemoji/pull/42)

## 3.1.2 - 2017.03.20

- Abstract constants into yaml files [#39](https://github.com/jollygoodcode/twemoji/pull/39)

## 3.1.1 - 2017.02.17

- Soften nokogiri dependency >= 1.6 [#38](https://github.com/jollygoodcode/twemoji/pull/38)

## 3.1.0 - 2016.12.13

- `Twemoji.parse` can now parse unicode values, too [#35](https://github.com/jollygoodcode/twemoji/pull/35)
  * [New API] `Twemoji.emoji_pattern_unicode` - List all emoji unicodes in a regex
  * [New API] `Twemoji.emoji_pattern_all` - List all emoji names and unicodes in a regex

## 3.0.2 - 2016.11.15

- Fix handling codepoint less than 0x1000 [#33](https://github.com/jollygoodcode/twemoji/pull/33)
- Fix strange naming of kiss emoji [#32](https://github.com/jollygoodcode/twemoji/pull/32)

## 3.0.1 - 2016.06.28

- Fix `img` tag `alt` attribute render incorrectly [#29](https://github.com/jollygoodcode/twemoji/pull/29)

## 3.0.0 - 2016.06.08

### Features

- Add support to twemoji.js V2
- Add `Twemoji.svg` (not loaded by default), looks like:

  ```ruby
  {
    ...
    ":heart_eyes:" => "https://twemoji.maxcdn.com/2/svg/1f60d.svg",
    ...
  }
  ```

- Add `Twemoji.png` (not loaded by default), looks like:

  ```ruby
  {
    ...
    ":heart_eyes:" => "https://twemoji.maxcdn.com/2/72x72/1f60d.png",
    ...
  }
  ```

### Breaking Changes

- Require Ruby 2.0+
- `Twemoji::CODES` changes to `Twemoji.codes`
- `Twemoji::ICODES` changes to `Twemoji.invert_codes`
- `asset_root` config default value changed to `https://twemoji.maxcdn.com/2`
- `file_ext` config default value changed to `svg`, available values are `"svg"` and `"png"`
- PNG now only has one size `72x72`
- Remove `Twemoji.to_json` method

### Bug fixes

- Fix `find_by_unicode` that only can find by single unicode [051f5a5](https://github.com/jollygoodcode/twemoji/commit/051f5a57c40f24d8d5caa65b462a9bee01545412)

## 2.2.1 - 2016.06.07

- Lose released Gem weight [#26](https://github.com/jollygoodcode/twemoji/pull/26)
- Add a `bin/hack` script to make gem development easier [#25](https://github.com/jollygoodcode/twemoji/pull/25)
- Add missing 47 emojis [#27](https://github.com/jollygoodcode/twemoji/pull/27)
- Fix emoji_pattern not properly escaped [#27](https://github.com/jollygoodcode/twemoji/pull/27)
- Change `:thumbsup:` `:thumbsdown:` to `:+1:` `:-1:`

## 2.1.1 - 2015.10.09

- Export JSON for SVG and PNG (16x16, 36x36, 72x72) [#18](https://github.com/jollygoodcode/twemoji/pull/18)

## 2.0.1 - 2015.07.19

- Soften Nokogiri dependency to ~> 1.6.2 (>= 1.6.2, < 1.7) [#19](https://github.com/jollygoodcode/twemoji/pull/19)

## 2.0.0 - 2015.05.29

- **Breaking change**: `Tewmoji.parse` `img_attr` option changed to `img_attrs` [#16](https://github.com/jollygoodcode/twemoji/pull/16)

  Old behaviour to specify `img` HTML attributes was passed in as a string to
  `img_attr` option from `Twemoji.parse`. **This API is removed**.

  Now please use `img_attrs` and passed in attribute-value pair you want in the
  form of Hash. You can now specify any HTML attributes to rendered emoji `img`.

  Note that the value of `img` tag attributes can be a proc-like object run
  against emoji name. Say if you do not want the colon from the title attribute
  of `img` tag. You can define a `no_colon = ->(name) { name.gsub(":", "") }`
  then passed into `Twemoji.parse` like below example:

  ```ruby
  > Twemoji.parse(":heart_eyes:", img_attrs: { title: no_colon })
  <img
    draggable="false"
    title="heart_eyes"
    alt=":heart_eyes:"
    src="https://twemoji.maxcdn.com/16x16/1f60d.png"
    class="twemoji"
  >
  ```

  ```ruby
  Twemoji.configure do |config|
    config.img_attrs = { style: "height: 1.3em;" }
  end
  ```

- Twemoji Configuration [#15](https://github.com/jollygoodcode/twemoji/pull/15)

  ```ruby
  Twemoji.configure do |config|
    config.asset_root = "https://twemoji.awesomecdn.com/"
    config.file_ext   = ".svg"
    config.image_size = nil # only png need to set size
    config.class_name = "twemoji"
    config.img_attr   = "style='height: 1.3em;'"
  end
  ```

## 1.1.0 - 2015.02.27

- Some more documentations @JuanitoFatas

- Behave more like twemoji.js. @bramswenson [#5](https://github.com/jollygoodcode/twemoji/pull/5)

  **New Methods**:

  * [`Twemoji.find_by`](https://github.com/jollygoodcode/twemoji/blob/fe2810ddbe1f2cfdb496bcdd9e1576ba1e05eb06/lib/twemoji.rb#L9-L35) now accepts `unicode` keyword argument (either a raw unicode or escaped-unicode string) to find emoji text

  * Add [`Twemoji.find_by_unicode`](https://github.com/jollygoodcode/twemoji/blob/fe2810ddbe1f2cfdb496bcdd9e1576ba1e05eb06/lib/twemoji.rb#L61-L71) to find emoji text by raw emoji unicode or escaped-unicode string

  * Add [`Twemoji.render_unicode`](https://github.com/jollygoodcode/twemoji/blob/fe2810ddbe1f2cfdb496bcdd9e1576ba1e05eb06/lib/twemoji.rb#L73-L86) to render raw emoji unicode from emoji text or emoji code

  **Changes**:

  * `img` tag's `alt` changes from emoji text like `:heart_eyes:` to actual unicode `"😍"`

- Restrict Nokogiri to (1.4..1.6.5). @JuanitoFatas [#3](https://github.com/jollygoodcode/twemoji/pull/3)

## 1.0.1 - 2015.01.13

- Add ability to specify img tag attribute. @JuanitoFatas [#1](https://github.com/jollygoodcode/twemoji/pull/1).
