class TagsController < ApplicationController

  # GET /tags
  # GET /tags.json
  def index
    @tags = ActsAsTaggableOn::Tag.most_used
  end

end
