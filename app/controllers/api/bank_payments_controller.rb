class Api::BankPaymentsController < ApplicationController
  before_action :authenticate_person!, except: [:index]
  # GET /api/bank_payments.json
  def index
    @bank_payments = BankPayment.order(id: :desc).limit(100)
    respond_to do |format|
      format.json
    end
  end
end
