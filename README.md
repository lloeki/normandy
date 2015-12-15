# Channels for ruby

A complete implementation of channels for Ruby, including size and close.

## How?

The usual `gem insall channel`, or `gem channel` in your `Gemfile`.

```
require 'channel'

c = Channel.new
go -> { c << 'Hello, world!' }
puts c.recv
```

## Why?

While some packages already exist, many fail at providing a thorough
implementation, often limited to `send`/`recv`, and most critically, all
missing `close` support. A complete implementation makes channels much more
useful, as most patterns rely much more details than simply `send`/`recv`.

To prove this point and to serve as a nice tutorial anyway, some examples
ported over from [Go by example](http://gobyexample.com) are included in
[examples](examples).

- [X] channels
- [X] channel buffering
- [X] channel synchronization
- [X] channel direction
- [X] select
- [X] timeouts
- [ ] non-block channel operations
- [X] closing channels
- [X] range over channels

## License

MIT
