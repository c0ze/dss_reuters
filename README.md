# DssReuters

A simple gem to extract info from DSS Reuters.

[![CircleCI](https://circleci.com/gh/c0ze/dss_reuters.svg?style=svg)](https://circleci.com/gh/c0ze/dss_reuters)

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

    DATA_SCOPE_USERNAME
    DATA_SCOPE_PASSWORD
    DATA_STREAM_USERNAME
    DATA_STREAM_PASSWORD

You can also set `DATA_SCOPE_LOG_LEVEL` or `DATA_STREAM_LOG_LEVEL` to set log level.

## Data Scope API

Usage flow goes like this :

    require "dss_reuters"
    api = DataScope::Api.new
    req = api.extract_with_isin "KE1000001402"
    req.get_result
    req.status # check if :completed. If :in_progress, check again
    req.result # Check result and get again if necessary

Default request fires a Composite extraction request. You can customize your request like :

    req = api.extract_with_isin "KE1000001402", :intraday_pricing, ["Life High", "Life Low", "Year High", "Year Low"]
    req = api.extract_with_isin "KE1000001402", :technical_indicators, ["Net Change - Close Price - 1 Day"]
    req = api.extract_with_isin "KE1000001402", :time_series, ["Close Price", "Trade Date"], {"StartDate" => "2018-01-01", "EndDate" => "2018-08-01"}

You can also use `extract_with_ric` to use Ric instrument identifiers.

    req = api.extract_with_ric "SCOM.NR"

## Data Stream API

Usage flow goes like this :

    require "dss_reuters"
    api = DataStream::Api.new
    res = api.ric_stream  ".TRXFLDAUTFIN", "2018-01-01", "2018-04-01"

You can also use ISIN identifiers as in Data Scope api.

    res = api.isin_stream  "SCOM.NR", "2018-01-01", "2018-04-01"

The request is synchronous, so results are available immediately.

### Getting ISIN for RIC or vs

You can use the DataScope api to get Isin code for a Ric code or vs

    req = api.extract_with_isin "KE1000001402", :composite, ["RIC", "Close Price", "ISIN"]

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dss_reuters. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DssReuters project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dss_reuters/blob/master/CODE_OF_CONDUCT.md).
