class CreateBankAccounts < ActiveRecord::Migration
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.string :description
      t.integer :account_type
      t.string :account_number
      t.string :bank_code
      t.decimal :balance
      t.string :token

      t.timestamps
    end
  end
end
