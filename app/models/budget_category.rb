class BudgetCategory < ActiveRecord::Base
  belongs_to :organization
  has_many :accountings

  def accounted_amount
  	accountings.sum(:amount)
  end

  def self.budget_category_types
    {
      "příjmy" => "income",
      "výdaje" => "outcome"
    }
  end

#  def paid_amount
#  	accountings.sum(:amount)
#  end

end
