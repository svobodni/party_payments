class StaticPagesController < ApplicationController

  skip_before_filter :authenticate_person!

  def index
  end

  def overview
		@bank_payments = BankPayment.includes(:payments).where("paid_on >= ? AND paid_on <= ?", "#{@year}-01-01", "#{@year}-12-31")
		@bank_payments = @bank_payments.reject{|p| p.remaining_amount == 0}
		@bank_payments = @bank_payments.reject{|p| p.returning_payment || p.returned_payment}
		@unpaired_invoices_balance = Invoice.includes(:payments, :accountings).reject{|p|
				p.payment_remainder == 0}.reject{|p|
				p.accountings.first.try(:budget_category).try(:year)!=@year
			}.inject(0){|t,p| t+=p.payment_remainder}
		@budget_current_balance = Budget.current_balance(@year)
		@unpaired_payments_balance = @bank_payments.inject(0){|t,b| t+=b.amount}
		@bank_accounts_balance = BankAccount.balance
  end

end
