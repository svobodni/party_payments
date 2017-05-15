class NonMonetaryDonationsController < ApplicationController
  before_action :set_non_monetary_donation, only: [:show, :edit, :update, :destroy]

  # GET /non_monetary_donations
  # GET /non_monetary_donations.json
  def index
    @non_monetary_donations = NonMonetaryDonation.all
  end

  # GET /non_monetary_donations/1
  # GET /non_monetary_donations/1.json
  def show
  end

  # GET /non_monetary_donations/new
  def new
    @non_monetary_donation = NonMonetaryDonation.new
  end

  # GET /non_monetary_donations/1/edit
  def edit
  end

  # POST /non_monetary_donations
  # POST /non_monetary_donations.json
  def create
    @non_monetary_donation = NonMonetaryDonation.new(non_monetary_donation_params)

    respond_to do |format|
      if @non_monetary_donation.save
        format.html { redirect_to @non_monetary_donation, notice: 'Non monetary donation was successfully created.' }
        format.json { render :show, status: :created, location: @non_monetary_donation }
      else
        format.html { render :new }
        format.json { render json: @non_monetary_donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /non_monetary_donations/1
  # PATCH/PUT /non_monetary_donations/1.json
  def update
    respond_to do |format|
      if @non_monetary_donation.update(non_monetary_donation_params)
        format.html { redirect_to @non_monetary_donation, notice: 'Non monetary donation was successfully updated.' }
        format.json { render :show, status: :ok, location: @non_monetary_donation }
      else
        format.html { render :edit }
        format.json { render json: @non_monetary_donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /non_monetary_donations/1
  # DELETE /non_monetary_donations/1.json
  def destroy
    @non_monetary_donation.destroy
    respond_to do |format|
      format.html { redirect_to non_monetary_donations_url, notice: 'Non monetary donation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_non_monetary_donation
      @non_monetary_donation = NonMonetaryDonation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def non_monetary_donation_params
      params.require(:non_monetary_donation).permit(:amount, :donor_type, :person_id, :name, :ic, :date_of_birth, :street, :city, :zip, :email, :agreement_received_on)
    end
end
