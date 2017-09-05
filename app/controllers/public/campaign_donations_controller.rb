class Public::CampaignDonationsController < ApplicationController
  layout 'public'

  skip_before_filter :authenticate_person!
  before_action :set_donation, only: [:show, :update, :signed]

  def index
    @campaign_donations = Donation.where("received_on > ?","2017-05-01").order(created_at: :desc)
    respond_to do |format|
      format.html
    end
  end

  # GET /donations/1
  # GET /donations/1.pdf
  def show
    respond_to do |format|
      format.html
      format.pdf {
        pdf = DonationAgreementPdf.new(@donation)
        send_data pdf.render,
                  filename: "svobodni_smlouva_#{@donation.access_token}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      }
    end
  end

  # GET /donations/new
  def new
    @donation = Donation.new(
      donor_type: params[:person_type]
    )
  end

  # POST /donations
  # POST /donations.json
  def create
    @donation = Organization.find(100).donations.new(donation_params)

    respond_to do |format|
      if @donation.save
        DonationsMailer.campaign_donation_agreement(@donation).deliver
        format.html { redirect_to [:public, :campaign, @donation], notice: 'Smlouva úspěšně vygenerována.' }
      else
        if @donation.vs_prefix
          @crowdfunding = Crowdfunding.find_by(vs_prefix: @donation.vs_prefix)
          format.html { render "public/crowdfundings/show" }
        else
          format.html { render :new }
        end
      end
    end
  end

  def update
    respond_to do |format|
      if @donation.update(params.require(:donation).permit(:agreement))
        format.html { redirect_to [:public, :campaign, @donation], notice: 'Smlouva úspěšně uložena, děkujeme.' }
      else
        format.html { render :show }
      end
    end
  end

  def signed
    respond_to do |format|
      format.pdf { send_file  @donation.agreement.path, type: 'application/pdf', disposition: :inline }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation
      @donation = Donation.find_by!(access_token: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def donation_params
      params.require(:donation).permit(:amount, :donor_type, :person_id, :name, :ic, :date_of_birth, :street, :city, :zip, :email, :description, :vs_prefix)
    end
end
