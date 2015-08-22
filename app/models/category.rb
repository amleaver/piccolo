class Category < ActiveRecord::Base
  belongs_to :budget
  belongs_to :txn, :class_name => "Transaction"

  validates :title, presence: true
  validates :budget_id, presence: true
end
