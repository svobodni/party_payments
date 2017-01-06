class AddApprovalToBudget < ActiveRecord::Migration
  def change
    add_column :budgets, :approved_url, :string
    add_column :budgets, :approval_url, :string
  end
end
