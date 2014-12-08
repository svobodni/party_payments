class Accounting < ActiveRecord::Base
  belongs_to :accountable, polymorphic: true
  belongs_to :budget_category

  acts_as_taggable
  before_save :set_tag_owner
  def set_tag_owner
    # Set the owner of some tags based on the current tag_list
    set_owner_tag_list_on(self.budget_category.organization, :tags, self.tag_list)
    # Clear the list so we don't get duplicate taggings
    self.tag_list = nil
  end
end
