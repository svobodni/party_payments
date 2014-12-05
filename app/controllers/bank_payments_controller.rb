class BankPaymentsController < ApplicationController
  def index
    @bank_payments = BankPayment.where("amount > 0")
    respond_to do |format|
      format.json { render json: @bank_payments }
    end
  end
end
