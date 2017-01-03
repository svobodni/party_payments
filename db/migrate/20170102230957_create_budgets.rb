class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.integer :organization_id
      t.integer :year
      t.decimal :opening_balance
      t.decimal :opening_bank_balance
      t.decimal :opening_cash_balance

      t.timestamps
    end
  end
end
