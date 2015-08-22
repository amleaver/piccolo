class Budget < ActiveRecord::Base
  has_many :transactions
  has_many :categories

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

  def category_titles
    categories.map(&:title)
  end

  def debit_chart_data
    chart_data(transactions.debit)
  end

  def credit_chart_data
    chart_data(transactions.credit)
  end

  private

  def chart_data(transactions)
    transactions.includes(:category).each_with_object({}) do |transaction, chart_data|
      title = transaction.category.present? ? transaction.category.title : 'Other'
      if chart_data.include?(title)
        chart_data[title] += transaction.monthly_amount.abs
      else
        chart_data[title] = transaction.monthly_amount.abs
      end
    end
  end
end
