# DssReuters

A simple gem to extract info from DSS Reuters.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dss_reuters'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dss_reuters

## Usage

You need to set your credentials as ENVs :

    DSS_USERNAME
    DSS_PASSWORD

You can also set `DSS_LOG_LEVEL` to set log level.

Usage flow goes like this :

    require "dss_reuters"
    api = DssReuters::Api.new
    req = api.extract_with_isin "KE1000001402"
    req.get_result
    req.result # Check result and get again if necessary

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dss_reuters. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DssReuters project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dss_reuters/blob/master/CODE_OF_CONDUCT.md).
