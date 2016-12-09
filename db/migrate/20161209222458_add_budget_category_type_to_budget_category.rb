class AddBudgetCategoryTypeToBudgetCategory < ActiveRecord::Migration
  def change
    add_column :budget_categories, :budget_category_type, :string
  end
end
