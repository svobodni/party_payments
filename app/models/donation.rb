class Donation < ActiveRecord::Base

  belongs_to :organization
  has_many :accountings, as: :accountable
  has_many :payments, as: :payable

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

  def received_on
    payments.try(:first).try(:payment).try(:paid_on)
  end

  def number
    "#{received_on.year}#{organization.id.to_s.rjust(2,'0')}#{id.to_s.rjust(3,'0')}"
  end

end
