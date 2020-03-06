# frozen_string_literal: true

require 'test_helper'

module AdjustedCostBase
  class TransactionsTest < Minitest::Test
    def test_parsing_transactions
      fixture = 'test/fixtures/transactions.csv'
      transactions = AdjustedCostBase::Transactions.new.parse_file(fixture)

      assert_equal 7, transactions.size
    end
  end
end
