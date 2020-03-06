# frozen_string_literal: true

class Security
  def initialize(symbol, initial_shares: 0, initial_total_acb: 0)
    @symbol = symbol
    @transactions = []
    @shares = initial_shares
    @total_acb = initial_total_acb
  end

  def buy(transaction)
    @transactions << transaction
    @shares += transaction.quantity
    @total_acb += transaction.total_amount + transaction.commission

    transaction.share_balance = @shares
    transaction.total_acb = @total_acb
  end

  def sell(transaction)
    @transactions << transaction
    transaction.capital_gain_or_loss = (transaction.price * transaction.quantity) - transaction.commission - ((@total_acb / @shares) * transaction.quantity)
    @total_acb = @total_acb * ((@shares - transaction.quantity) / @shares)
    @shares -= transaction.quantity
    transaction.share_balance = @shares
    transaction.total_acb = @total_acb
  end
end
