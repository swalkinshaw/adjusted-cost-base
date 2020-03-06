# frozen_string_literal: true

module AdjustedCostBase
  class Calculator
    def initialize(transactions)
      @transactions = transactions
    end

    def calculate(symbol, initial_acb: 0, initial_shares: 0)
      security = Security.new(symbol, initial_total_acb: initial_acb, initial_shares: initial_shares)

      securities = @transactions.each_with_object(Hash.new { |h, k| h[k] = [] }) do |t, h|
        h[t.symbol] << t
      end

      transactions_by_symbol = securities.fetch(symbol)

      transactions_by_symbol.each_with_index do |t, i|
        case t.action
        when 'Buy'
          security.buy(t)

          puts "#{t.settlement_date} => #{t.action}"
          puts "#{t.total_amount} (#{t.quantity} * #{t.price})"
          puts "Share balance: #{t.share_balance}"
          puts "New ACB: #{t.total_acb}"
          puts "ACB/share: #{t.acb_per_share}"
        when 'Sell'
          security.sell(t)
          puts sprintf('%-.2f', t.capital_gain_or_loss)
        else
          raise "Invalid action: #{t.action}. Supported actions: 'Buy', 'Sell'"
        end
      end
    end
  end
end
