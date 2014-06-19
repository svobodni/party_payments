class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :type
      t.integer :bank_payment_id
      t.decimal :amount
      t.date :paid_on
      t.integer :person_id
      t.string :name
      t.string :address
      t.date :born_on
      t.string :region_id

      t.timestamps
    end
  end
end
