class AccountingsController < ApplicationController
  before_action :set_accounting, only: [:show, :edit, :update, :destroy]

  # GET /accountings
  # GET /accountings.json
  def index
    #@invoice = Invoice.find(params[:invoice_id])
    @accountings = Accounting.all #[]#@invoice.accountings
    @accounting = Accounting.new
    #@accounting = @invoice.accountings.build(amount: @invoice.accounting_remainder)
    if params[:tag]
      @accountings = Accounting.tagged_with(params[:tag])
    else
      @accountings = Accounting.all
    end
  end

  # GET /accountings/1
  # GET /accountings/1.json
  def show
  end

  # GET /accountings/new
  def new
    @accounting = Accounting.new
  end

  # GET /accountings/1/edit
  def edit
  end

  # POST /accountings
  # POST /accountings.json
  def create
    @accounting = Accounting.new(accounting_params)

    respond_to do |format|
      if @accounting.save
        format.html { redirect_to @accounting, notice: 'Accounting was successfully created.' }
        format.json { render :show, status: :created, location: @accounting }
      else
        format.html { render :new }
        format.json { render json: @accounting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accountings/1
  # PATCH/PUT /accountings/1.json
  def update
    respond_to do |format|
      if @accounting.update(accounting_params)
        format.html { redirect_to @accounting, notice: 'Accounting was successfully updated.' }
        format.json { render :show, status: :ok, location: @accounting }
      else
        format.html { render :edit }
        format.json { render json: @accounting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accountings/1
  # DELETE /accountings/1.json
  def destroy
    @accounting.destroy
    respond_to do |format|
      format.html { redirect_to accountings_url, notice: 'Accounting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accounting
      @accounting = Accounting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def accounting_params
      params.require(:accounting).permit(:accountable_type, :accountable_id, :budget_category_id, :amount, :tag_list)
    end
end
