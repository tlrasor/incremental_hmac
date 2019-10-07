# incremental_hmac

[![Build Status](https://travis-ci.org/tlrasor/incremental_hmac.svg?branch=master)](https://travis-ci.org/tlrasor/incremental_hmac)

The standard library's HMAC implementation is rather limited in that it can only work on data that has a `to_slice` method defined. This works fine for the typical web use cases for strings and byte buffers but does not scale well to calculating the HMAC of large files which are inconvenient to fit in memory.

This shard monkey patches OpenSSL::HMAC and adds an incremental interface modeled on Ruby's OpenSSL::HMAC class. It does this by calling into the same LibCrypto wrapper that the standard library does and should be fairly safe for production use.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     incremental_hmac:
       github: tlrasor/incremental_hmac
   ```

2. Run `shards install`

## Usage

```crystal
require "incremental_hmac"
```

For deeper usage, see the supplied helper functions.

#### Helpers

There are some helpers which can handle reading the data in from a file

```crystal
key = "<some secret hmac key>"
path = Path["<some file path string>"]
digest = OpenSSL::HMAC.hexdigest(OpenSSL::Algorithm::SHA256, key, path)
```

## Development

Do some dev and write some tests plz

## Contributing

1. Fork it (<https://github.com/tlrasor/incremental_hmac/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Travis Rasor](https://github.com/tlrasor) - creator and maintainer
