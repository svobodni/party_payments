class GopayPaymentsController < ApplicationController

  def index
    @gopay_payments = GopayPayment.order(paid_on: :desc)
    if params[:only]=="unpaired"
      @gopay_payments = @gopay_payments.reject{|p| p.remaining_amount == 0}
    end
  end

end
