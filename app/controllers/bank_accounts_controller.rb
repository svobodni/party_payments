class BankAccountsController < ApplicationController
  before_action :set_organization
  before_action :set_bank_account, only: [:show, :edit, :update, :destroy]

  # GET /bank_accounts
  # GET /bank_accounts.json
  def index
    @bank_accounts = BankAccount.accessible_by(current_ability).all
  end

  # GET /bank_accounts/1
  # GET /bank_accounts/1.json
  def show
    @bank_payments=@bank_account.payments.accessible_by(current_ability).order(created_at: :desc).page params[:page]
  end

  # GET /bank_accounts/new
  def new
    @bank_account = BankAccount.new
    authorize! :create, @bank_account
  end

  # GET /bank_accounts/1/edit
  def edit
    authorize! :update, @bank_account
  end

  # POST /bank_accounts
  # POST /bank_accounts.json
  def create
    @bank_account = BankAccount.new(bank_account_params)
    authorize! :create, @bank_account
    respond_to do |format|
      if @bank_account.save
        format.html { redirect_to bank_accounts_path, notice: 'Nový bankovní účet byl úspěšně uložen.' }
        format.json { render :show, status: :created, location: @bank_account }
      else
        format.html { render :new }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bank_accounts/1
  # PATCH/PUT /bank_accounts/1.json
  def update
    authorize! :update, @bank_account
    respond_to do |format|
      if @bank_account.update(bank_account_params)
        format.html { redirect_to bank_accounts_path, notice: 'Bankovní účet byl úspěšně uložen.' }
        format.json { render :show, status: :ok, location: @bank_account }
      else
        format.html { render :edit }
        format.json { render json: @bank_account.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_account
      @bank_account = BankAccount.find(params[:id])
    end

    def set_organization
      @organization = Organization.find(100)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bank_account_params
      params.require(:bank_account).permit(:name, :description, :account_type, :account_number, :bank_code, :balance, :token)
    end
end
