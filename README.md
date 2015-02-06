# scrambled_eggs

Easy data scrambler

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'scrambled_eggs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scrambled_eggs

## Usage

Default key is **/etc/hostname** file.

### Scramble (encrypt)
```Ruby
egg = ScrambledEggs.new
scrambled = egg.scramble( data )
```

### Descramble (decrypt)
```Ruby
egg = ScrambledEggs.new
descrambled = egg.descramble( scrambled )
```

### Advanced
```Ruby
egg = ScrambledEggs.new( algorithm: 'aes-128-cbc', key: 'Password' )
scrambled = egg.scramble( data )
descrambled = egg.descramble( scrambled )
```

## Copyright

Author:

* sanadan <jecy00@gmail.com>

Copyright:

* Copyright (c) 2015 sanadan

License:

* MIT

## Contributing

1. Fork it ( https://github.com/sanadan/scrambled_eggs/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

