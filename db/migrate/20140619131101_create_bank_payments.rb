class CreateBankPayments < ActiveRecord::Migration
  def change
    create_table :bank_payments, force: true do |t|
      t.string   :accounting_status
      t.string   :accounting_note

      t.integer  :transaction_id
      t.date	 :payed_on
      t.decimal  :amount,        precision: 10, scale: 2
      t.string   :currency
      t.string   :account_name
      t.string   :info
      t.string   :vs
      t.string   :ss
      t.string   :ks
      t.string   :account_number
      t.string   :bank_code

      t.timestamps
    end
  end
end
