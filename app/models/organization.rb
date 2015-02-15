class Organization < ActiveRecord::Base
  has_many :budget_categories
  has_many :invoices
  has_many :donations
  has_many :bank_payments

  acts_as_tagger
end
