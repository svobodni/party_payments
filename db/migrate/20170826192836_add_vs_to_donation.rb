class AddVsToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :vs, :string
  end
end
