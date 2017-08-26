class NonMonetaryDonationsController < ApplicationController
  before_action :set_organization
  before_action :set_non_monetary_donation, only: [:upload, :agreement, :update]

  def index
    @non_monetary_donations = NonMonetaryDonation.all

    if params[:year]
      @non_monetary_donations = @non_monetary_donations.where("created_at >= ? AND created_at <= ?", "#{params[:year]}-01-01", "#{params[:year]}-12-31")
    end

    respond_to do |format|
      format.html {
        @non_monetary_donations = @non_monetary_donations.order(created_at: :desc).page params[:page]
      }
      # format.xlsx
    end
  end

  def upload
  end

  def agreement
    authorize! :read, @non_monetary_donation
    respond_to do |format|
      format.pdf do
        pdf = DonationAgreementPdf.new(@non_monetary_donation)
        send_data pdf.render,
                  filename: "svobodni_smlouva_#{@non_monetary_donation.id}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  def update
    respond_to do |format|
      if @non_monetary_donation.update(params.require(:non_monetary_donation).permit(:agreement))
        format.html { redirect_to non_monetary_donations_path, notice: 'Smlouva úspěšně uložena.' }
      else
        format.html { render :upload }
      end
    end
  end

  private
  def set_non_monetary_donation
    @non_monetary_donation = NonMonetaryDonation.find_by_access_token(params[:id])
  end

  def set_organization
    @organization = Organization.find(100)
  end

end
