class BankPaymentsController < ApplicationController

  # GET /bank_payments
  # GET /bank_payments.json
  def index
    @organization = Organization.find_by_id(params[:organization_id])
    if @organization
      @bank_payments = @organization.bank_payments
    else
      @bank_payments = BankPayment.all
    end
    @bank_payments = @bank_payments.order(paid_on: :desc)
  end

end
