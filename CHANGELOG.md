# CHANGELOG

## Unreleased

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
