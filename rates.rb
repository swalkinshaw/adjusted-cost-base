require 'date'
require 'json'

def find_newest_fx_rate(date)
  rate = RAW_RATES[date.strftime('%Y-%m-%d')]
  return rate if rate

  find_newest_fx_rate(date - 1)
end

RAW_RATES = JSON.parse(File.read('2018-usd-cad-raw.json'))['observations'].each_with_object({}) do |rate, rates|
  rates[rate['d']] = rate['FXUSDCAD']['v']
end

complete_rates = {}

Date.new(2018, 01, 01).upto(Date.new(2018, 12, 31)) do |date|
  complete_rates[date.strftime('%Y-%m-%d')] = find_newest_fx_rate(date)
end

File.write('2018-usd-cad.json', JSON.dump(complete_rates))
