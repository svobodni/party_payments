class MembershipFeesController < ApplicationController
  before_action :set_membership_fee, only: [:show, :edit, :update, :destroy]

  # GET /membership_fees
  # GET /membership_fees.json
  def index
    if params[:organization_id]!="100"
      @membership_fees = Organization.find(params[:organization_id]).membership_fees
    else
      @membership_fees = MembershipFee.all
    end
  end

  def distribution
    @membership_fees_distribution = MembershipFee.find_by_year_and_quarter(params[:year],params[:quarter])
  end

#  # GET /membership_fees/1
#  # GET /membership_fees/1.json
#  def show
#  end

  # GET /membership_fees/new
  def new
    @membership_fee = MembershipFee.new(
      amount: params[:amount],
      bank_payment_id: params[:bank_payment_id],
      person_id: params[:vs][1..-1]
    )
    authorize! :create, @donation
  end

#  # GET /membership_fees/1/edit
#  def edit
#  end
#
  # POST /membership_fees
  # POST /membership_fees.json
  def create
    @bank_payment = BankPayment.find(params[:membership_fee][:bank_payment_id])
    @membership_fee = MembershipFee.new(membership_fee_params)
    @membership_fee.payments.build(payment: @bank_payment)
    @membership_fee.payments.first.amount = params[:membership_fee][:amount]
    @membership_fee.received_on = @bank_payment.paid_on
    authorize! :create, @membership_fee

    respond_to do |format|
      if @membership_fee.save
        format.html { redirect_to @membership_fee, notice: 'Membership fee was successfully created.' }
        format.json { render :show, status: :created, location: @membership_fee }
      else
        format.html { render :new }
        format.json { render json: @membership_fee.errors, status: :unprocessable_entity }
      end
    end
  end

#
#  # PATCH/PUT /membership_fees/1
#  # PATCH/PUT /membership_fees/1.json
#  def update
#    respond_to do |format|
#      if @membership_fee.update(membership_fee_params)
#        format.html { redirect_to @membership_fee, notice: 'Membership fee was successfully updated.' }
#        format.json { render :show, status: :ok, location: @membership_fee }
#      else
#        format.html { render :edit }
#        format.json { render json: @membership_fee.errors, status: :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /membership_fees/1
#  # DELETE /membership_fees/1.json
#  def destroy
#    @membership_fee.destroy
#    respond_to do |format|
#      format.html { redirect_to membership_fees_url, notice: 'Membership fee was successfully destroyed.' }
#      format.json { head :no_content }
#    end
#  end
#
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership_fee
      @membership_fee = MembershipFee.find(params[:id])
    end
#
    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_fee_params
      params.require(:membership_fee).permit(:region_id, :amount, :person_id, :name)
    end
end
