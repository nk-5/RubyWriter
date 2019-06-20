# RubyWriter

Ruby is not [ruby](https://www.ruby-lang.org/ja/).
This is converter, kanji to hiragana.

## Example

input: `中川慶悟` -> output: `なかがわけいご`

## Requirements

* Xcode 10.2
* Swift 5.0
* iOS 12.0+
* [Bundler](https://bundler.io/)
```
$ gem install bundler
```

* [goo API id](https://labs.goo.ne.jp/api/jp/hiragana-translation/)

## Architecture

MVVM

## Installation

```
$ make GOO_APP_ID=set-goo-app-id
```

## Future support

* input text from camera!!
  * use [Firebase MLKit Recognize Text](https://firebase.google.com/docs/ml-kit/ios/recognize-text)
