class AddIndexToPayments < ActiveRecord::Migration
  def change
    add_index :payments, [:payable_id, :payable_type]
  end
end
