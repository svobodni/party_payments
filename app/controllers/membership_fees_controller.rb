class MembershipFeesController < ApplicationController
  before_action :set_membership_fee, only: [:show, :edit, :update, :destroy]

  # GET /membership_fees
  # GET /membership_fees.json
  def index
    @membership_fees = MembershipFee.all
  end

  def distribution
    @membership_fees_distribution = MembershipFee.find_by_year_and_quarter(params[:year],params[:quarter])
  end

#  # GET /membership_fees/1
#  # GET /membership_fees/1.json
#  def show
#  end
#
#  # GET /membership_fees/new
#  def new
#    @membership_fee = MembershipFee.new
#  end
#
#  # GET /membership_fees/1/edit
#  def edit
#  end
#
#  # POST /membership_fees
#  # POST /membership_fees.json
#  def create
#    @membership_fee = MembershipFee.new(membership_fee_params)
#
#    respond_to do |format|
#      if @membership_fee.save
#        format.html { redirect_to @membership_fee, notice: 'Membership fee was successfully created.' }
#        format.json { render :show, status: :created, location: @membership_fee }
#      else
#        format.html { render :new }
#        format.json { render json: @membership_fee.errors, status: :unprocessable_entity }
#      end
#    end
#  end
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
#    # Never trust parameters from the scary internet, only allow the white list through.
#    def membership_fee_params
#      params.require(:membership_fee).permit(:region_id, :amount, :person_id, :name)
#    end
end
