class BankPaymentsController < ApplicationController
  def index
    @bank_payments = BankPayment.all
    respond_to do |format|
      format.json { render json: @bank_payments }
    end
  end
end
