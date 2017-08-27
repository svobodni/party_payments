class Public::CrowdfundingsController < ApplicationController

  layout 'public'

  def index
    @crowdfunding = Crowdfunding.all
  end

  def show
    @crowdfunding = Crowdfunding.find(params[:id])
  end

end
