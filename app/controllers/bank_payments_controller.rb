class BankPaymentsController < ApplicationController

  # GET /bank_payments
  # GET /bank_payments.json
  def index
    # @organization = Organization.find_by_id(params[:organization_id])
    if @organization
      @bank_payments = @organization.bank_payments.includes(:payments)
    else
      @bank_payments = BankPayment.all
    end
    if params[:year]
      @bank_payments = @bank_payments.where("paid_on >= ? AND paid_on <= ?", "#{params[:year]}-01-01", "#{params[:year]}-12-31")
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

  def show
    @organization = Organization.find(100)
    @bank_payment = BankPayment.find(params[:id])
  end

  def pair
    @bank_payment = BankPayment.find(params[:id])
    @bank_payment.pair
    redirect_to :back, notice: 'Párování provedeno.'
  end

end
