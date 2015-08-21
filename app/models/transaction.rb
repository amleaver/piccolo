class Transaction < ActiveRecord::Base
  belongs_to :budget

  TXN_TYPES = ['Debit', 'Credit']
  OCCURS = ['Daily', 'Weekly', 'Monthly', 'Yearly']

  validates :payee, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :txn_type, presence: true, inclusion: { in: Transaction::TXN_TYPES }
  validates :occurs, presence: true, inclusion: { in: Transaction::OCCURS }
end
