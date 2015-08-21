class Budget < ActiveRecord::Base
  has_many :transactions

  validates :title, presence: true
end
