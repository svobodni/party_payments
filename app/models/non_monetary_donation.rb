require 'securerandom'

class NonMonetaryDonation < ActiveRecord::Base
  before_create :set_access_token
  after_create :send_email_with_agreement
  before_update :set_agreement_received_on

  validates :amount, presence: true
  validates :description, presence: true
  validates :donor_type, presence: true
  # validates :person_id
  validates :name, presence: true
  validates :ic, presence: true, if: :juristic?
  validates :date_of_birth, presence: true, unless: :juristic?
  validates :street, presence: true
  validates :city, presence: true
  validates :zip, presence: true
  validates :email, presence: true

  scope :agreement_received, -> { where("agreement_received_on IS NOT NULL") }

  has_attached_file :agreement, path: ":rails_root/data/non_monetary_agreements/:id.pdf", url: "/smlouvy-nepenezni/:id.pdf"
  validates_attachment :agreement, content_type: { content_type: ["application/pdf"], message: "musí být PDF" }

  def monetary?
    false
  end

  def address
    "#{street}, #{zip} #{city}"
  end

  def to_param
    access_token
  end

  def juristic?
    donor_type == "juristic"
  end

  private
  def set_access_token
    self.access_token = SecureRandom.hex
  end

  def send_email_with_agreement
    DonationsMailer.non_monetary_agreement(self).deliver
  end

  def set_agreement_received_on
    self.agreement_received_on = Date.today if agreement_file_size
  end

end
