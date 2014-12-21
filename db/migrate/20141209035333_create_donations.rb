class CreateDonations < ActiveRecord::Migration
  def change
    create_table :donations do |t|
      t.integer :organization_id
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

      t.timestamps
    end
  end
end
