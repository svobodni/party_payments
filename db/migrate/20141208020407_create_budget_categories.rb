class CreateBudgetCategories < ActiveRecord::Migration
  def change
    create_table :budget_categories do |t|
      t.integer :organization_id
      t.integer :year
      t.string :name

      t.timestamps
    end
  end
end
