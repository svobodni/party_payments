class AddOrganizationToBankPayment < ActiveRecord::Migration
  def change
    add_column :bank_payments, :organization_id, :integer
  end
end
