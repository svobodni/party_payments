class ChangeDecimalPrecision < ActiveRecord::Migration
  def change
    change_column :budgets, :opening_balance, :decimal, precision: 10, scale: 2
    change_column :budgets, :opening_bank_balance, :decimal, precision: 10, scale: 2
    change_column :budgets, :opening_cash_balance, :decimal, precision: 10, scale: 2
    change_column :membership_fees, :amount, :decimal, precision: 10, scale: 2
    change_column :bank_accounts, :balance, :decimal, precision: 10, scale: 2
  end
end
