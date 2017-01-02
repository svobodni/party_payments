class BudgetCategory < ActiveRecord::Base
  belongs_to :organization
  has_many :accountings

  validates :amount, :numericality => { :greater_than_or_equal_to => 0 }

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
