class SupporterFeesController < ApplicationController
  def index
    @supporter_fees = SupporterFee.all
    respond_to do |format|
      format.json { render json: @supporter_fees }
    end
  end
end
