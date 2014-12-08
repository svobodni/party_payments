class Accounting < ActiveRecord::Base
  belongs_to :accountable, polymorphic: true
  belongs_to :budget_category
end
