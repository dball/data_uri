[![Specs](https://github.com/aredotna/data_uri/actions/workflows/ruby.yml/badge.svg)](https://github.com/aredotna/data_uri/actions/workflows/ruby.yml)

# Data URI

## Introduction

Data URIs allow resources to be embedded inside a URI. The URI::Data class
provides support for parsing these URIs using the normal URI.parse method.

I wrote it to support embedding binary data inside JSON messages in a
relatively reasonable way. If you find some other use for it, please drop me
a line.

## Usage

```ruby
require 'data_uri'

uri = URI::Data.new('data:image/gif;base64,...')
uri.content_type # image/gif
uri.data # Base64 decoded data
```

Data URIs can play nicely with open-uri:

```ruby
require 'open-uri'
require 'data_uri/open_uri'

open(uri) do |io|
  io.content_type # image/gif
  io.read # decoded data
end
```

There is no support for creating data URI strings, but it would be trivial to add if anyone's interested.

## Features & Limitations

URI.parse knows about URI::Data, but unfortunately, its regexp for splitting
URIs into components maxes out at 92 characters for an opaque URI, which is
far too small to be useful for data URIs.

It accepts URIs with charset MIME parameters:

```
data:text/html;charset=utf-8,...
```

and if the String object has a force_encoding method, as in ruby-1.9.x, it
will call it with the value of the charset parameter on the decoded data.
Other MIME parameters are parsed and stored, but are not exposed.

The base64 pseudo-parameter must appear immediately prior to the data, as per the RFC. Google Chrome apparently misbehaves in this regard, so if this
causes grief to anyone, yell and I'll relax the constraint. If base64 coding
is not specified, the data are URI decoded.

Some non-authoritative documentation about data URIs state that whitespace
is allowed and ignored within them. The RFC seems to contradict this
interpretation, but support seems to be widespread in the browser world.
URI::Data cannot parse URIs containing whitespace. If
this causes grief to anyone, yell and I'll either add a class method to
URI::Data for explicit relaxed parsing, and/or figure out how to convince
URI::Generic to be more open minded about the kinds of URIs it allows.

Even when using the open-uri support file, Kernel.open will not accept string data URIs, only URI::Data objects. Open-uri is opinionated about the
formats of the URIs it will try to open, and it's ambiguous to me at least if data URIs can necessarily be distinguished from filesystem paths on all
platforms. Again, if this causes undue pain and suffering, we can commit
minor violence to open-uri to convince it to see reason.

## License:

(The MIT License)

Copyright (c) 2010 Donald Ball <donald.ball@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
