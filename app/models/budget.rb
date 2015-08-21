class Budget < ActiveRecord::Base
  has_many :transactions

  validates :title, presence: true

  def credit_total
    transactions.credit.inject(BigDecimal.new(0)){|sum, txn| sum + txn.monthly_amount}
  end

  def debit_total
    transactions.debit.inject(BigDecimal.new(0)){|sum, txn| sum + txn.monthly_amount}
  end

  def total
    credit_total + debit_total
  end
end
