class AddReceivedOnToDonation < ActiveRecord::Migration
  def change
    add_column :donations, :received_on, :date
  end
end
