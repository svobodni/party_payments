class DonationsController < ApplicationController
  before_action :set_donation, only: [:show, :edit, :update, :destroy, :confirmation, :agreement, :upload]
  respond_to :pdf, only: [:confirmation, :agreement]

  # GET /donations
  # GET /donations.json
  def index
    @donations = @organization ? @organization.donations : Donation.all
    @donations = @donations.includes(accountings:[accountable: [payments: :payment]])
    @donations = @donations.accessible_by(current_ability)

    # if params[:year]
    #   @donations = @donations.where("received_on >= ? AND received_on <= ?", "#{params[:year]}-01-01", "#{params[:year]}-12-31")
    # end

    respond_to do |format|
      format.html {
        @donations = @donations.order(created_at: :desc).page params[:page]
      }
      format.xlsx
    end
  end

  def above_limit
    # @organization = Organization.find_by_id(params[:organization_id])
    if @organization && @organization.id != 100
      @donations = @organization.donations
    else
      @donations = Donation.all
    end
    if params[:limit]
      @donations = @donations.where("amount > ?", params[:limit])
    else
      @donations = @donations.where("amount > 1000")
    end
    @donations = @donations.accessible_by(current_ability)
    @donations = @donations.order(created_at: :desc).page params[:page]
    render action: :index
  end

  def crowdfunding
    @donations = Donation.where("vs like '99%' and LENGTH(vs)=8")
    @donations = @donations.accessible_by(current_ability)
    @donations = @donations.order(created_at: :desc).page params[:page]
  end

  # GET /donations/1
  # GET /donations/1.json
  def show
    authorize! :read, @donation
  end

  # GET /donations/new
  def new
    @donation = Donation.new(
      organization: @organization,
      amount: params[:amount],
      bank_payment_id: params[:bank_payment_id],
      budget_category_id: 4,
      person_id: params[:vs][1..-1]
    )
    authorize! :create, @donation
  end

  # GET /donations/1/edit
  def edit
    authorize! :update, @donation
  end

  # POST /donations
  # POST /donations.json
  def create
    @bank_payment = BankPayment.find(params[:donation][:bank_payment_id])
    @donation = Donation.new(donation_params)
    @donation.payments.build(payment: @bank_payment)
    @donation.payments.first.amount = params[:donation][:amount]
    @donation.received_on = @bank_payment.paid_on
    #@donation.accountings.build(budget_category_id: params[:donation][:budget_category_id])
    #@donation.accountings.first.amount = params[:donation][:amount]
    authorize! :create, @donation

    respond_to do |format|
      if @donation.save
        format.html { redirect_to @donation, notice: 'Donation was successfully created.' }
        format.json { render :show, status: :created, location: @donation }
      else
        format.html { render :new }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /donations/1
  # PATCH/PUT /donations/1.json
  def update
    authorize! :update, @donation
    respond_to do |format|
      if @donation.update(donation_params)
        format.html { redirect_to @donation, notice: 'Donation was successfully updated.' }
        format.json { render :show, status: :ok, location: @donation }
      else
        format.html { render :edit }
        format.json { render json: @donation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /donations/1
  # DELETE /donations/1.json
  def destroy
    authorize! :destroy, @donation
    @donation.destroy
    respond_to do |format|
      format.html { redirect_to donations_url, notice: 'Donation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def confirmation
    authorize! :read, @donation
    respond_to do |format|
      format.pdf {}
    end
  end

  def agreement
    authorize! :read, @donation
    respond_to do |format|
      format.pdf do
        pdf = DonationAgreementPdf.new(@donation)
        send_data pdf.render,
                  filename: "svobodni_smlouva_#{@donation.id}.pdf",
                  type: 'application/pdf',
                  disposition: 'inline'
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_donation
      @donation = Donation.friendly.find(params[:id])
      @organization = @donation.organization
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def donation_params
      params.require(:donation).permit(:organization_id, :amount, :donor_type, :person_id, :name, :ic, :date_of_birth, :street, :city, :zip, :email, :agreement)
    end
end
