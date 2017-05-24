class AddAgreementToNonMonetaryDonation < ActiveRecord::Migration
  def up
    add_attachment :non_monetary_donations, :agreement
  end

  def down
    remove_attachment :non_monetary_donations, :agreement
  end
end
