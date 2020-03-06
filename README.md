# AdjustedCostBase

A Ruby library and CLI for calculating the [Adjusted Cost Base](https://www.investopedia.com/terms/a/adjustedcostbase.asp)(ABC) for tax purposes.

Currently this library is limited to working with a CSV file of transactions from [Questrade](https://www.questrade.com/). Other brokerages may be supported in the future.
This library follows the ACB calculation as detailed by [adjustedcostbase.ca](https://www.adjustedcostbase.ca/blog/how-to-calculate-adjusted-cost-base-acb-and-capital-gains/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'adjusted_cost_base'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install adjusted_cost_base
```

## Usage

After exporting an Excel file of transactions from Questrade (and converting to CSV), run the following:

```bash
acb <path_to_transactions.csv> <TICKER_SYMBOL>
```

Basic example for a new stock purchase:

```bash
acb transactions.csv GOOG
```

Re-calculating ACB for a future year after already owning the investment:
```bash
acb transactions.csv GOOG --acb=950 --shares=10
```

## Features

* Calculates the ACB for one stock at a time
* Can optionally supply initial shares or ACB for existing investments
* Includes CAD -> USD foreign exchange conversions

## Limitations

* Only supports Questrade's CSV output of transactions
* No support for phantom distributions ([ref](https://www.adjustedcostbase.ca/blog/phantom-distributions-and-their-effect-on-adjusted-cost-base/))
* No support for reinvested distributions ([ref](https://www.adjustedcostbase.ca/blog/calculating-adjusted-cost-base-with-reinvested-distributions-dividend-reinvestment-plans-drips/))

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/adjusted_cost_base. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the AdjustedCostBase project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/adjusted_cost_base/blob/master/CODE_OF_CONDUCT.md).
