class CreateMembershipFees < ActiveRecord::Migration
  def change
    create_table :membership_fees do |t|
      t.integer :region_id
      t.decimal :amount
      t.integer :person_id
      t.string :name
      t.date :received_on

      t.timestamps
    end
  end
end
