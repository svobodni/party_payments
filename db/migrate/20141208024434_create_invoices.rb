class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :organization_id
      t.string :description
      t.decimal :amount, precision: 10, scale: 2
      t.string :vs
      t.string :ss
      t.string :ks
      t.string :account_number
      t.string :bank_code
      t.attachment :document

      t.timestamps
    end
  end
end
