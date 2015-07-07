class CreateDonationFormSubmissions < ActiveRecord::Migration
  def change
    create_table :donation_form_submissions do |t|
      t.text :params

      t.timestamps
    end
  end
end
