class Invoice < ActiveRecord::Base

  belongs_to :organization
  has_many :accountings, as: :accountable
  has_many :payments, as: :payable

  has_attached_file :document #, path: ":rails_root/data/invoices/:id.pdf", url: "/people/:person_id/signed_application.pdf"
  validates_attachment :document, content_type: { content_type: "application/pdf" }

  def accounting_remainder
  	amount.to_f-accountings.sum(:amount)
  end

  def payment_remainder
  	amount.to_f-payments.sum(:amount)
  end

end
