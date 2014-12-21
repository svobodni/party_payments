class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :payment_type
      t.integer :payment_id
      t.decimal :amount, precision: 10, scale: 2
      t.string :payable_type
      t.integer :payable_id

      t.timestamps
    end
  end
end
