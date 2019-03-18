require 'csv'
require 'pry'
require 'optparse'

InitialACB = Struct.new(:share_balance, :total_acb, keyword_init: true)

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

USD_CAD_RATES = JSON.parse(File.read('2018-usd-cad.json'))

def parse_transactions(file)
  transactions = []

  CSV.foreach(file, headers: :first_row, converters: :all) do |row|
    transaction_date = DateTime.parse(row['Transaction Date'])
    price = row['Price']

    price = case row['Currency']
    when 'CAD'
      price
    when 'USD'
      rate = USD_CAD_RATES.fetch(transaction_date.strftime('%Y-%m-%d'))
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
    )
  end

  transactions.sort_by!(&:settlement_date)
end

def calculate(transactions, symbol, initial_acb: 0, initial_shares: 0)
  security = Security.new(symbol, initial_total_acb: initial_acb, initial_shares: initial_shares)

  securities = transactions.each_with_object(Hash.new { |h, k| h[k] = [] }) do |t, h|
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
      raise 'invalid action'
    end
  end
end

options = { acb: 0, shares: 0 }

OptionParser.new do |opts|
  opts.banner = 'Usage: acb.rb [options] <TRANSACTIONS> <SYMBOL>'

  opts.on('--acb[=ACB]', Integer, 'Initial total Adjusted Cost Base (default: 0)') do |acb|
    options[:acb] = acb
  end

  opts.on('--shares[=SHARES]', Integer, 'Initial quantity of shares (default: 0)') do |shares|
    options[:shares] = shares
  end

  opts.on('-h', '--help', "Prints this help") do
    puts opts
    exit
  end
end.parse!

transactions_file = ARGV.shift
raise 'Need to specify a transactions file to process' unless transactions_file

symbol = ARGV.shift
raise 'Need to specify a symbol' unless symbol

transactions = parse_transactions(transactions_file)
calculate(transactions, symbol, initial_acb: options[:acb], initial_shares: options[:shares])
