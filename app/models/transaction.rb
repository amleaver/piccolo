class Transaction < ActiveRecord::Base
  belongs_to :budget

  TXN_TYPES = ['Debit', 'Credit']
  OCCURS = ['Daily', 'Daily (Mon-Fri)', 'Weekly', 'Monthly', 'Yearly']

  validates :payee, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :txn_type, presence: true, inclusion: { in: Transaction::TXN_TYPES }
  validates :occurs, presence: true, inclusion: { in: Transaction::OCCURS }
  validates :budget_id, presence: true

  scope :credit, -> { where(txn_type: 'Credit') }
  scope :debit, -> { where(txn_type: 'Debit') }



  def monthly_amount
    days_in_month = 365 / 12
    weeks_in_month = days_in_month / 7
    working_days_in_month = (days_in_month / 7) * 5
    monthly_amount = BigDecimal.new(0)

    case occurs
      when 'Weekly'
        monthly_amount = amount * weeks_in_month
      when 'Daily'
        monthly_amount = amount * days_in_month
      when 'Daily (Mon-Fri)'
        monthly_amount = amount * working_days_in_month
      when 'Monthly'
        monthly_amount = amount
      when 'Yearly'
        monthly_amount = (amount / 365) * days_in_month
    end

    monthly_amount = monthly_amount * -1 if txn_type == 'Debit'

    monthly_amount.round(2)
  end
end
