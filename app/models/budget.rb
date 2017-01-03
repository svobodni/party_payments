class Budget < ActiveRecord::Base

  belongs_to :organization

  def budget_categories
    BudgetCategory.where(year: year, organization_id: organization_id)
  end

end
