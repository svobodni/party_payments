class AddAgreementToDonation < ActiveRecord::Migration
  def up
    add_attachment :donations, :agreement
  end

  def down
    remove_attachment :donations, :agreement
  end
end
