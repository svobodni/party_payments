class MembershipFee < ActiveRecord::Base

  belongs_to :region, class_name: 'Organization'
  has_many :accountings, as: :accountable
  has_many :payments, as: :payable
  before_create :set_accounting

  attr_accessor :bank_payment_id, :budget_category_id

  def self.account
    '2100382818'
  end

  def self.find_by_year_and_quarter(year,quarter)
    grouped_by_quarter_and_region.select{|key,val| key[0..6]=="#{year}, #{quarter}"}
  end

  def self.grouped_by_quarter_and_region
    all.group_by {|mf| "#{mf.received_on.year}, #{((mf.received_on.month - 1) / 3) + 1}, #{mf.region_id}"}
  end

  def set_accounting
    if received_on > Date.parse("2020-12-31")
      self.accountings.build(budget_category_id: 553, amount: amount/2)
      self.accountings.build(budget_category_id: self.region.budgets.where(year:2021).first.membership_fee_budget_category_id, amount: amount/2)
    elsif received_on > Date.parse("2019-12-31")
      self.accountings.build(budget_category_id: 455, amount: amount/2)
      self.accountings.build(budget_category_id: self.region.budgets.where(year:2020).first.membership_fee_budget_category_id, amount: amount/2)
    elsif received_on > Date.parse("2018-12-31")
      self.accountings.build(budget_category_id: 371, amount: amount/2)
      self.accountings.build(budget_category_id: self.region.budgets.where(year:2019).first.membership_fee_budget_category_id, amount: amount/2)
    elsif received_on > Date.parse("2017-12-31")
      self.accountings.build(budget_category_id: 262, amount: amount/2)
      self.accountings.build(budget_category_id: self.region.budgets.where(year:2018).first.membership_fee_budget_category_id, amount: amount/2)
    elsif received_on > Date.parse("2016-12-31")
      self.accountings.build(budget_category_id: 165, amount: amount/2)
      self.accountings.build(budget_category_id: self.region.budgets.where(year:2017).first.membership_fee_budget_category_id, amount: amount/2)
    elsif received_on > Date.parse("2015-12-31")
      self.accountings.build(budget_category_id: 49, amount: amount)
    elsif received_on > Date.parse("2014-12-31")
      self.accountings.build(budget_category_id: 8, amount: amount)
    end if accountings.empty?
  end

end
