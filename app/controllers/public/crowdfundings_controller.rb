class Public::CrowdfundingsController < ApplicationController

  layout 'public'
  skip_before_filter :authenticate_person!

  def index
    @crowdfunding = Crowdfunding.all
  end

  def show
    @crowdfunding = Crowdfunding.find(params[:id])
  end

end
