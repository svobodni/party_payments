class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy, :pay, :export_to_fio, :approval]
  before_action :set_invoices, only: [:index, :unpaid, :unpaired, :unrecognized, :unreaded, :unapproved]

  # GET /invoices
  # GET /invoices.json
  def index
    @page_title = "Faktury - #{@organization.try(:name)}"
  end

  def unpaid
    @invoices = @invoices.reject{|p| p.payment_remainder == 0}
    @page_title = "Nezaplacené faktury - #{@organization.try(:name)}"
    render :index
  end

  def unpaired
    @invoices = @invoices.reject{|p| p.accounting_remainder == 0}
    @page_title = "Faktury nepřiřazené do rozpočtové kapitoly - #{@organization.try(:name)}"
    render :index
  end

  def unrecognized
    @invoices = @invoices.select{|p| p.organization.blank?}
    @page_title = "Faktury nepřiřazené žádnému kraji ani republice"
    render :index
  end

  def unreaded
    @invoices = @invoices.select{|p| p.account_number.blank?}
    @page_title = "Faktury čekající na vytěžení platebních instrukcí - #{@organization.try(:name)}"
    render :index
  end

  def unapproved
#    @invoices = @invoices.where.not(approved: true)
    @page_title = "Faktury čekající na vyznačení schválení - #{@organization.try(:name)}"
    render :index
  end

  # GET /invoices/1
  # GET /invoices/1.json
  # GET /invoices/1.pdf
  def show
    @invoice.events.create(default_event_params.merge({
      name: "InvoiceDisplayed",
      data: params
    }))
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
    render layout: 'invoice_edit'
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    authorize! :create, @invoice

    respond_to do |format|
      if @invoice.save
        @invoice.events.create(default_event_params.merge({
          name: "InvoiceCreated",
          changes: @invoice.previous_changes
        }))
        format.html { redirect_to @invoice, notice: 'Faktura byla úspěšně uložena.' }
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
        @invoice.events.create(default_event_params.merge({
          name: "InvoiceUpdated",
          changes: @invoice.previous_changes
        }))
        format.html { redirect_to @invoice, notice: 'Faktura byla úspěšně upravena.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  # def destroy
  #   authorize! :destroy, @invoice
  #   @invoice.destroy
  #   respond_to do |format|
  #     format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  def pay
    authorize! :pay, @invoice
  end

  def approval
    authorize! :approve, @invoice
  end

  def export_to_fio
    authorize! :pay, @invoice

    result = @invoice.import_transaction_to_fio(params[:invoice][:account], params[:invoice][:description])
    @invoice.events.create(default_event_params.merge({
      name: "InvoicePaid",
      data: result.inspect
    }))

    redirect_to(@invoice, :notice => "Import do Fio banky proběhl. Výsledek: #{result.inspect}")
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.accessible_by(current_ability).find(params[:id])
      @organization=@invoice.organization
    end

    def set_invoices
      if @organization
        @invoices = @organization.invoices
      else
        @invoices = Invoice.all
      end
      @invoices = @invoices.accessible_by(current_ability)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(:description, :amount, :vs, :ss, :ks, :account_number, :bank_code, :document, :organization_id, :approved_on, :approval_url)
    end
end
