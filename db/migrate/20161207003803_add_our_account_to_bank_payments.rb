class AddOurAccountToBankPayments < ActiveRecord::Migration
  def change
    add_column :bank_payments, :our_account_number, :string
    add_column :bank_payments, :our_bank_code, :string
  end
end
