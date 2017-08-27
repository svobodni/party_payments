class AddAccessTokenToDonation < ActiveRecord::Migration
  def up
    add_column :donations, :access_token, :string
    Donation.all.each{|d|
      d.update_attribute :access_token, SecureRandom.hex
    }
  end

  def down
    remove_column :donations, :access_token, :string
  end
end
