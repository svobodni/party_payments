class CreateGopayPayments < ActiveRecord::Migration
  def change
    create_table :gopay_payments do |t|
      t.string :transaction_id
      t.date :paid_on
      t.float :amount
      t.string :currency
      t.string :account_name
      t.string :info
      t.string :vs
      t.string :reference_id
      t.datetime :paid_at

      t.timestamps
    end
  end
end
