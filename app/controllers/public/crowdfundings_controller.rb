class Public::CrowdfundingsController < ApplicationController

  layout 'crowdfunding'
  skip_before_filter :authenticate_person!
  def default_url_options
    {}
  end

  def index
    @crowdfunding = Crowdfunding.all
    @og_title="Zviditelněte Svobodné"
    @og_url=public_crowdfundings_url
    @og_description="Namixujte kampaň Svobodných podle svých představ, aby Svobodní uspěli ve volbách. Můžeme být svobodnou zemí."
    @og_image=ActionController::Base.helpers.image_url "facebook-crowdfunding.jpg"
  end

  def show
    @crowdfunding = Crowdfunding.find(params[:id])
    @og_title="Zviditelněte Svobodné: #{@crowdfunding.title}"
    @og_url=public_crowdfunding_url(params[:id])
    @og_description=@crowdfunding.perex
    @og_image=ActionController::Base.helpers.image_url "crowdfunding/#{@crowdfunding.image_url}"
    @donation = Donation.new(vs_prefix:@crowdfunding.vs_prefix, amount: @crowdfunding.price)
  end

end
