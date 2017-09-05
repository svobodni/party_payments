class Public::CrowdfundingsController < ApplicationController

  layout 'crowdfunding'
  skip_before_filter :authenticate_person!

  def index
    @crowdfunding = Crowdfunding.all
  end

  def show
    @crowdfunding = Crowdfunding.find(params[:id])
    @donation = Donation.new(vs_prefix:@crowdfunding.vs_prefix, amount: @crowdfunding.price)
  end

end
