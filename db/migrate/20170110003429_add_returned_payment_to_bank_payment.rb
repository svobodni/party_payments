class AddReturnedPaymentToBankPayment < ActiveRecord::Migration
  def change
    add_column :bank_payments, :returned_payment_id, :integer
  end
end
