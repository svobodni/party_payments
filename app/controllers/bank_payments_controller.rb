class BankPaymentsController < ApplicationController

  # GET /bank_payments
  # GET /bank_payments.json
  def index
    @organization = Organization.find_by_id(params[:organization_id])
    if @organization
      @bank_payments = BankPayment.where(organization_id: @organization.id).includes(:payments)
    else
      @bank_payments = BankPayment.all
    end
    @bank_payments = @bank_payments.order(paid_on: :desc)
    if params[:only]=="unpaired"
      @bank_payments = @bank_payments.reject{|p| p.remaining_amount == 0}
    elsif params[:only]=="incoming"
      @bank_payments = @bank_payments.select{|p| p.amount > 0}
    elsif params[:only]=="outgoing"
      @bank_payments = @bank_payments.select{|p| p.amount < 0}
    end
  end

end
