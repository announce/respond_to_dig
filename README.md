RespondToDig
===

[![Build Status](https://travis-ci.org/announce/respond_to_dig.svg?branch=master)](https://travis-ci.org/announce/respond_to_dig)

This gem backports Array#dig and Hash#dig methods from Ruby 2.3+ to earlier versions of Ruby, only if you explicitly call it.

## vs [RubyDig](https://github.com/Invoca/ruby_dig)
* RubyDig has side-effects, but RespondToDig doesn't.
* RespondToDig only supports `Array` and `Hash`, but RespondToDig supports any `Enumerable` objects which have `[]` method such as `Struct`.

## Installation

Add this line to your application's `Gemfile`:

```ruby
gem 'respond_to_dig'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install respond_to_dig

## Usage

```rb
require 'respond_to_dig'

h = RespondToDig::respond_to_dig({ foo: {bar: {baz: 1 }}})
h.dig(:foo, :bar, :baz)           #=> 1
h.dig(:foo, :zot, :xyz)           #=> nil
h.dig(:foo, :bar, :baz, :xyz)     #=> TypeError

g = RespondToDig::respond_to_dig({ foo: [10, 11, 12] })
g.dig(:foo, 1)                    #=> 11
```

For the details, refer [Module: RespondToDig — Documentation](http://www.rubydoc.info/gems/respond_to_dig/RespondToDig).
