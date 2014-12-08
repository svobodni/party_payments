class BudgetCategory < ActiveRecord::Base
  belongs_to :organization
  has_many :accountings

  def accounted_amount
  	accountings.sum(:amount)
  end

#  def paid_amount
#  	accountings.sum(:amount)
#  end

end
