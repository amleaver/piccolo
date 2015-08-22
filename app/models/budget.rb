class Budget < ActiveRecord::Base
  has_many :transactions

  validates :title, presence: true

  def credit_total
    transactions.credit.inject(BigDecimal.new(0)) { |a, e| a + e.monthly_amount }
  end

  def debit_total
    transactions.debit.inject(BigDecimal.new(0)) { |a, e| a + e.monthly_amount }
  end

  def total
    credit_total + debit_total
  end
end
