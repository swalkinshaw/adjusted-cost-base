# frozen_string_literal: true

require 'csv'

module AdjustedCostBase
  class Transactions
    def initialize
      fx_files = Dir.glob("#{__dir__}/data/*.json")

      @fx_rates = fx_files.each_with_object({}) do |rates_file, rates|
        year = File.basename(rates_file).split('-')[0]
        rates[year.to_i] = JSON.parse(File.read(rates_file))
      end
    end

    def parse_file(file_path)
      transactions = []

      CSV.foreach(file_path, headers: :first_row, converters: :all) do |row|
        transaction_date = DateTime.parse(row['Transaction Date'] || row['Trade Date'])
        price = row['Price']

        price = case row['Currency']
        when 'CAD'
          price
        when 'USD'
          rate = @fx_rates.dig(transaction_date.year, transaction_date.strftime('%Y-%m-%d'))
          raise "FX rate for #{transaction_date} not found." unless rate

          price * rate
        else
          raise 'unsupported currency'
        end

        transactions << Transaction.new(
          action: row['Action'],
          symbol: row['Symbol'],
          transaction_date: transaction_date,
          settlement_date: DateTime.parse(row['Settlement Date']),
          quantity: row['Quantity'].abs,
          price: price,
          commission: row['Commission'].abs,
          currency: row['Currency'],
        ).freeze
      end

      transactions.sort_by!(&:settlement_date)
    end
  end
end
