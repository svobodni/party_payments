class MembershipFee < ActiveRecord::Base

  belongs_to :region, class: Organization
  has_many :accountings, as: :accountable
  has_many :payments, as: :payable
  before_create :set_accounting

  attr_accessor :bank_payment_id, :budget_category_id

  def self.find_by_year_and_quarter(year,quarter)
    grouped_by_quarter_and_region.select{|key,val| key[0..6]=="#{year}, #{quarter}"}
  end

  def self.grouped_by_quarter_and_region
    all.group_by {|mf| "#{mf.received_on.year}, #{((mf.received_on.month - 1) / 3) + 1}, #{mf.region_id}"}
  end

  def set_accounting
    if received_on > Date.parse("2014-12-31")
      self.accountings.build(budget_category_id: 8, amount: amount)
    end if accountings.empty?
  end

end
