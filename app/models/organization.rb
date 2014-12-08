class Organization < ActiveRecord::Base
  has_many :budget_categories
  has_many :invoices
  has_many :bank_payments
end
