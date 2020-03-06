# frozen_string_literal: true

require 'date'
require 'json'
require 'net/http'

class RatesConverter
  def initialize(year)
    @year = year.to_i
    @start_of_year = Date.new(@year, 01, 01)
    @end_of_year = Date.new(@year, 12, 31)
  end

  def write
    response = download_rates
    rates = parse_rates(response.body)
    converted = convert_rates(rates)

    File.write("#{year}-usd-cad.json", JSON.dump(converted))
  end

  private

  attr_reader :year, :start_of_year, :end_of_year

  def convert_rates(rates)
    start_of_year.upto(end_of_year).each_with_object({}) do |date, complete_rates|
      rate = find_closest_rate(rates, date)
      complete_rates[date.to_s] = rate if rate
    end
  end

  def download_rates
    rates_uri = URI('https://www.bankofcanada.ca/valet/observations/FXUSDCAD/json')
    rates_uri.query = URI.encode_www_form(start_date: start_of_year.to_s, end_date: end_of_year.to_s)

    Net::HTTP.get_response(rates_uri)
  end

  def find_closest_rate(rates, date)
    rate = rates[date.to_s]
    return rate if rate

    if date.day > 1
      find_closest_rate(rates, date - 1)
    end
  end

  def parse_rates(raw_rates)
    JSON.parse(raw_rates)['observations'].each_with_object({}) do |rate, rates|
      rates[rate['d']] = rate['FXUSDCAD']['v']
    end
  end
end
