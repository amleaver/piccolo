class Transaction < ActiveRecord::Base
  belongs_to :budget
  belongs_to :category

  # attr_accessor :category

  TXN_TYPES = {
    debit: 'Debit',
    credit: 'Credit'
  }

  OCCURS = {
    daily: 'Daily',
    daily_mon_fri: 'Daily (Mon-Fri)',
    weekly: 'Weekly',
    monthly: 'Monthly',
    yearly: 'Yearly'
  }

  validates :payee, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :txn_type, presence: true, inclusion: { in: TXN_TYPES.values }
  validates :occurs, presence: true, inclusion: { in: OCCURS.values }
  validates :budget_id, presence: true

  scope :credit, -> { where(txn_type: TXN_TYPES[:credit]) }
  scope :debit, -> { where(txn_type: TXN_TYPES[:debit]) }

  def self.txn_types_list
    TXN_TYPES.values
  end

  def self.occurs_list
    OCCURS.values
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/AbcSize
  def monthly_amount
    days_in_month = 365 / 12
    weeks_in_month = days_in_month / 7
    working_days_in_month = (days_in_month / 7) * 5
    monthly_amount = BigDecimal.new(0)

    case occurs
      when OCCURS[:weekly]
        monthly_amount = amount * weeks_in_month
      when OCCURS[:daily]
        monthly_amount = amount * days_in_month
      when OCCURS[:daily_mon_fri]
        monthly_amount = amount * working_days_in_month
      when OCCURS[:monthly]
        monthly_amount = amount
      when OCCURS[:yearly]
        monthly_amount = (amount / 365) * days_in_month
    end

    monthly_amount *= -1 if txn_type == TXN_TYPES[:debit]

    monthly_amount.round(2)
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def category_name
    category.present? ? category.title : ''
  end
end
