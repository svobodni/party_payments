class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  # GET /invoices
  # GET /invoices.json
  def index
    @organization = Organization.find_by_id(params[:organization_id])
    if @organization
      @invoices = @organization.invoices
    else
      @invoices = Invoice.all
    end
    if params[:only]=="unpaid"
      @invoices = @invoices.reject{|p| p.payment_remainder == 0}
    elsif params[:only]=="unpaired"
      @invoices = @invoices.reject{|p| p.accounting_remainder == 0}
    elsif params[:only]=="unrecognized"
      @invoices = @invoices.select{|p| p.organization.blank?}
    elsif params[:only]=="unreaded"
      @invoices = @invoices.select{|p| p.account_number.blank?}
    end

  end

  # GET /invoices/1
  # GET /invoices/1.json
  # GET /invoices/1.pdf
  def show
    respond_to do |format|
      format.html
      format.json
      format.pdf { send_file  @invoice.document.path, type: @invoice.document_content_type, disposition: :inline }
    end
  end

  # GET /invoices/new
  def new
    @invoice = Invoice.new(organization_id: params[:organization_id])
  end

  # GET /invoices/1/edit
  def edit
    authorize! :update, @invoice
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    authorize! :create, @invoice

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invoices/1
  # PATCH/PUT /invoices/1.json
  def update
    authorize! :update, @invoice
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find(params[:id])
      @organization=@invoice.organization
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(:description, :amount, :vs, :ss, :ks, :account_number, :bank_code, :document, :organization_id)
    end
end
