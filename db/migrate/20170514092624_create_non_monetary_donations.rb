class CreateNonMonetaryDonations < ActiveRecord::Migration
  def change
    create_table :non_monetary_donations do |t|
      t.decimal :amount
      t.string :donor_type
      t.integer :person_id
      t.string :name
      t.string :ic
      t.string :date_of_birth
      t.string :street
      t.string :city
      t.string :zip
      t.string :email
      t.date :agreement_received_on

      t.timestamps
    end
  end
end
