class CreateAccountings < ActiveRecord::Migration
  def change
    create_table :accountings do |t|
      t.string :accountable_type
      t.integer :accountable_id
      t.integer :budget_category_id
      t.string :payment_type
      t.integer :payment_id
      t.decimal :amount

      t.timestamps
    end
  end
end
