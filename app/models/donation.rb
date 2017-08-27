class Donation < ActiveRecord::Base

  belongs_to :organization
  has_many :accountings, as: :accountable
  has_many :payments, as: :payable
  before_create :set_accounting
  before_create :set_access_token
  after_create :set_vs

  attr_accessor :bank_payment_id, :budget_category_id, :vs_prefix

  has_attached_file :agreement, path: ":rails_root/data/donation_agreements/:id.pdf", url: "/darovaci-smlouvy/:id.pdf"
  validates_attachment :agreement, content_type: { content_type: ["application/pdf"], message: "musí být PDF" }

  validates :amount, presence: true
  # validates :description, presence: true
  validates :donor_type, presence: true
  # validates :person_id
  validates :name, presence: true
  validates :ic, presence: true, if: :juristic?
  validates :date_of_birth, presence: true, unless: :juristic?
  validates :street, presence: true
  validates :city, presence: true
  validates :zip, presence: true
  validates :email, presence: true

  extend FriendlyId
  friendly_id :access_token

  def monetary?
    true
  end

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

  def juristic?
    donor_type == "juristic"
  end

  def number
    "#{received_on.year}#{organization.id.to_s.rjust(2,'0')}#{id.to_s.rjust(3,'0')}"
  end

  def payment_received_on
    received_on
  end

  def agreement_received_on
    @agreement_received_on = agreement_updated_at
  end

  def needs_agreement?
    amount > 1000
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
    end if accountings.empty? && received_on
  end

  private
  def set_access_token
    self.access_token = SecureRandom.hex
  end

  def set_vs
    self.update_attribute :vs, "#{self.vs_prefix}#{self.id.to_s.rjust(6,'0')}" if self.vs.blank?
  end
end
