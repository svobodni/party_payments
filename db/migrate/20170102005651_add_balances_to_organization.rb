class AddBalancesToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :bank_balance, :decimal, precision: 10, scale: 2
    add_column :organizations, :cash_balance, :decimal, precision: 10, scale: 2
  end
end
