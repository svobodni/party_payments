class AddAnotherIndexToPayments < ActiveRecord::Migration
  def change
    add_index :payments, [:payment_id, :payment_type]
  end
end
