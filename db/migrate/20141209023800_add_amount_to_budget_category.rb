class AddAmountToBudgetCategory < ActiveRecord::Migration
  def change
    add_column :budget_categories, :amount, :decimal
  end
end
