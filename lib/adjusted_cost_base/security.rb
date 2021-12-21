# frozen_string_literal: true

class Security
  def initialize(symbol, initial_shares: 0, initial_total_acb: 0)
    @symbol = symbol
    @transactions = []
    @shares = initial_shares
    @total_acb = initial_total_acb
  end

  def add_transaction(transaction)
  end

  def buy(transaction)
    @shares += transaction.quantity

    @transactions << Transaction.new(
      **transaction.to_h,
      share_balance: @shares,
    )
  end

  def sell(transaction)
    @total_acb *= (@shares - transaction.quantity) / @shares
    @shares -= transaction.quantity

    capital_gain_or_loss = (transaction.price * transaction.quantity) - transaction.commission - ((@total_acb / @shares) * transaction.quantity)

    @transactions << Transaction.new(
      **transaction.to_h,
      capital_gain_or_loss: capital_gain_or_loss,
      share_balance: @shares,
      total_acb: @total_acb
    )
  end
end
