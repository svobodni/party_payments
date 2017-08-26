class Public::CampaignDonationsController < ApplicationController
  layout 'public'

  skip_before_filter :authenticate_person!

  def index
    @campaign_donations = Donation.where("received_on > ?","2017-05-01").order(created_at: :desc)
    respond_to do |format|
      format.html
    end
  end
end
