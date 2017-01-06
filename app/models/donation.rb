class Donation < ActiveRecord::Base

  belongs_to :organization
  has_many :accountings, as: :accountable
  has_many :payments, as: :payable
  before_create :set_accounting

  attr_accessor :bank_payment_id, :budget_category_id

  def address
    "#{street}, #{zip} #{city}"
  end

  def date_of_birth
    begin
      Date.parse(super.to_s)
    rescue
      super
    end
  end

  def number
    "#{received_on.year}#{organization.id.to_s.rjust(2,'0')}#{id.to_s.rjust(3,'0')}"
  end

  def set_accounting
    if received_on > Date.parse("2016-12-31")
      if organization_id==100
        self.accountings.build(budget_category_id: 166, amount: amount)
      else
        self.accountings.build(budget_category_id: self.organization.budgets.where(year:2017).first.donation_budget_category_id, amount: amount)
      end
    elsif received_on > Date.parse("2015-12-31")
      self.accountings.build(budget_category_id: 50, amount: amount) if organization_id==100
    elsif received_on > Date.parse("2014-12-31")
      self.accountings.build(budget_category_id: 11, amount: amount) if organization_id==100
    end if accountings.empty?
  end

end
