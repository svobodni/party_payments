class AddApprovalToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :approved_on, :date
    add_column :invoices, :approval_url, :string
  end
end
