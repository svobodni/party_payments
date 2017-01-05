class Budget < ActiveRecord::Base

  belongs_to :organization

  def budget_categories
    @budget_categories ||= BudgetCategory.where(year: year, organization_id: organization_id)
  end

  def balances
    @balances ||= budget_categories.group(:budget_category_type).sum(:amount)
  end

  def incomes_balance
    balances["income"]
  end

  def outcomes_balance
    balances["outcome"]
  end

  def accounted_incomes_balance
    @accounted_incomes_balance ||= budget_categories.where(budget_category_type: "income").inject(0){|total,cat| total+=cat.accounted_amount }
  end

  def accounted_outcomes_balance
    @accounted_outcomes_balance ||= budget_categories.where(budget_category_type: "outcome").inject(0){|total,cat| total+=cat.accounted_amount }
  end

end
