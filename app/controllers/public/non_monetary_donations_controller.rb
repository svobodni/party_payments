class Public::NonMonetaryDonationsController < ApplicationController
  layout 'public'

  skip_before_filter :authenticate_person!
  before_action :set_non_monetary_donation, only: [:show, :update, :signed]
  # GET /non_monetary_donations
  # GET /non_monetary_donations.json
  def index
    @non_monetary_donations = NonMonetaryDonation.agreement_received.order(created_at: :desc)
    respond_to do |format|
      format.html
    end
  end

  # GET /non_monetary_donations/1
  # GET /non_monetary_donations/1.pdf
  def show
    respond_to do |format|
      format.html
      format.pdf {
        pdf = DonationAgreementPdf.new(@non_monetary_donation)
        send_data pdf.render,
                  filename: "svobodni_smlouva_#{@non_monetary_donation.access_token}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      }
    end
  end

  # GET /non_monetary_donations/new
  def new
    @non_monetary_donation = NonMonetaryDonation.new(
      donor_type: params[:person_type]
    )
  end

  # POST /non_monetary_donations
  # POST /non_monetary_donations.json
  def create
    @non_monetary_donation = NonMonetaryDonation.new(non_monetary_donation_params)

    respond_to do |format|
      if @non_monetary_donation.save
        format.html { redirect_to [:public, @non_monetary_donation], notice: 'Smlouva úspěšně vygenerována.' }
        format.json { render :show, status: :created, location: @non_monetary_donation }
      else
        format.html { render :new }
        format.json { render json: @non_monetary_donation.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @non_monetary_donation.update(params.require(:non_monetary_donation).permit(:agreement))
        format.html { redirect_to [:public, @non_monetary_donation], notice: 'Smlouva úspěšně uložena, děkujeme.' }
        format.json { render :show, status: :ok, location: @non_monetary_donation }
      else
        format.html { render :show }
        format.json { render json: @non_monetary_donation.errors, status: :unprocessable_entity }
      end
    end
  end

  def signed
    respond_to do |format|
      format.pdf { send_file  @non_monetary_donation.agreement.path, type: 'application/pdf', disposition: :inline }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_non_monetary_donation
      @non_monetary_donation = NonMonetaryDonation.find_by(access_token: params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def non_monetary_donation_params
      params.require(:non_monetary_donation).permit(:amount, :donor_type, :person_id, :name, :ic, :date_of_birth, :street, :city, :zip, :email, :description)
    end
end
