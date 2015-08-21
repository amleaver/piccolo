class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :payee
      t.text :notes
      t.string :txn_type
      t.string :occurs
      t.decimal :amount
      t.references :budget, index: true
      t.timestamps null: false
    end

    add_foreign_key :transactions, :budgets
  end
end
