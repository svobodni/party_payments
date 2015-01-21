require 'test_helper'

class DonationTest < ActiveSupport::TestCase
  def create_donation
    @donation = FactoryGirl.build(:donation)
    @donation.save!
  end

  test 'PDF confirmation' do
    create_donation

    assert_nothing_raised do
      @donation.confirmation_pdf
    end
  end

  test 'PDF agreement' do
    create_donation

    assert_nothing_raised do
      @donation.agreement_pdf
    end
  end
end
