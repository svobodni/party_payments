class OrganizationsController < ApplicationController

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.all
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @organization = Organization.find(params[:id])
    @bank_balance = if @organization.id==100
      BankAccount.sum(:balance)-Organization.sum(:bank_balance)
    else
      @organization.bank_balance
    end
    @cash_balance = @organization.cash_balance
    @balance = @bank_balance||0 + @cash_balance||0
  end
end
