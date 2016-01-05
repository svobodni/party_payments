class Donation < ActiveRecord::Base

  belongs_to :organization
  has_many :accountings, as: :accountable
  has_many :payments, as: :payable
  before_create :set_accounting

  attr_accessor :bank_payment_id, :budget_category_id, :received_on

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

  def received_on
    @received_on ||= payments.try(:first).try(:payment).try(:paid_on)
  end

  def number
    "#{received_on.year}#{organization.id.to_s.rjust(2,'0')}#{id.to_s.rjust(3,'0')}"
  end

  def set_accounting
    if received_on > Date.parse("2015-12-31")
      self.accountings.build(budget_category_id: 50, amount: amount) if organization_id==100
    elsif received_on > Date.parse("2014-12-31")
      self.accountings.build(budget_category_id: 11, amount: amount) if organization_id==100
    end if accountings.empty?
  end

end
