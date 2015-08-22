class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title, unique: true
      t.references :budget, index: true

      t.timestamps null: false
    end
  end
end
