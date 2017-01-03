class Organization < ActiveRecord::Base
  has_many :budget_categories
  has_many :invoices
  has_many :donations
  has_many :membership_fees, foreign_key: :region_id
  has_many :bank_payments
  has_many :budgets

  acts_as_tagger

  extend FriendlyId
  friendly_id :slug, use: [:slugged, :finders]
end
