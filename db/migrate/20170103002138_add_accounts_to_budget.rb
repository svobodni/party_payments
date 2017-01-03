class AddAccountsToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :membership_fee_budget_category_id, :integer
    add_column :budgets, :donation_budget_category_id, :integer
  end
end
