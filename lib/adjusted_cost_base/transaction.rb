# frozen_string_literal: true

Transaction = Struct.new(
  :action,
  :symbol,
  :transaction_date,
  :settlement_date,
  :quantity,
  :price,
  :commission,
  :currency,
  :capital_gain_or_loss,
  :acb_per_share,
  :total_acb,
  :share_balance,
  keyword_init: true
) do
  def acb_per_share
    @acb_per_share ||= total_acb / share_balance
  end

  def total_amount
    @total_amount ||= price * quantity
  end
end
