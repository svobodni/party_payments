class Accounting < ActiveRecord::Base
  belongs_to :accountable, polymorphic: true
  belongs_to :budget_category
  belongs_to :payment, polymorphic: true

  acts_as_taggable
end
