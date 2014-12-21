class Donation < ActiveRecord::Base

  belongs_to :organization
  has_many :accountings, as: :accountable
  has_many :payments, as: :payable

  attr_accessor :bank_payment_id, :budget_category_id

  def address
  	"#{street}, #{zip} #{city}"
  end

end
