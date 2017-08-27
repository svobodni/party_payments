class Public::CrowdfundingsController < ApplicationController

  layout 'public'

  def index
    @crowdfunding = Crowdfunding.all
  end

  def show
    @crowdfunding = Crowdfunding.find(params[:id])
  end

  def create
    @donation = @donation.create
    # @donation_form_su = NonMonetaryDonation.new(non_monetary_donation_params)
    # @donation_form_submission = DonationFormSubmission.create(params: params)

    respond_to do |format|
      if @non_monetary_donation.save
        format.html { redirect_to @non_monetary_donation, notice: 'Smlouva úspěšně vygenerována.' }
        format.json { render :show, status: :created, location: @non_monetary_donation }
      else
        format.html { render :new }
        format.json { render json: @non_monetary_donation.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def non_monetary_donation_params
      params.require(:non_monetary_donation).permit(:amount, :donor_type, :person_id, :name, :ic, :date_of_birth, :street, :city, :zip, :email, :description)
    end
end
