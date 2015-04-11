class StaticPagesController < ApplicationController

  skip_before_filter :authenticate_person!

  def index
  end
end
