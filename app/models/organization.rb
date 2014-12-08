class Organization < ActiveRecord::Base
  has_many :budget_categories
end
