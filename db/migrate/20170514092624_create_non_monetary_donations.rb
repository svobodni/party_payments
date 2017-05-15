class CreateNonMonetaryDonations < ActiveRecord::Migration
  def change
    create_table :non_monetary_donations do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.string :description
      t.string :donor_type
      t.integer :person_id
      t.string :name
      t.string :ic
      t.date :date_of_birth
      t.string :street
      t.string :city
      t.string :zip
      t.string :email
      t.date :agreement_received_on
      t.string :access_token
      t.timestamps
    end
  end
end
