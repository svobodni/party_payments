class TagsController < ApplicationController

  # GET /tags
  # GET /tags.json
  def index
    if @organization
      @tags = @organization.owned_tags
    else
      @tags = ActsAsTaggableOn::Tag.most_used
    end
  end

end
