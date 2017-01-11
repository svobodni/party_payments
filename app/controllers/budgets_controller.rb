class BudgetsController < ApplicationController

  before_action :set_budget, only: [:show, :edit, :update]

  def show
    @budget_categories = @budget.budget_categories
  end

  def index
    @budgets = Budget.where(year: @year)
  end

  def edit
    authorize! :update, @budget
  end

  def update
    authorize! :update, @budget
    respond_to do |format|
      if @budget.update(budget_params)
        format.html { redirect_to organization_budget_path(@budget.organization, year: @budget.year), notice: 'Rozpočet byl úspešně upraven.' }
        format.json { render :show, status: :ok, location: @budget }
      else
        format.html { render :edit }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget
      @budget = if params[:id]
        Budget.find(params[:id])
      else
        Budget.find_or_create_by(organization_id: @organization.id, year: @year)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_params
      params.require(:budget).permit(:opening_balance, :opening_bank_balance, :opening_cash_balance, :membership_fee_budget_category_id, :donation_budget_category_id, :approval_url, :approved_url)
    end
end
