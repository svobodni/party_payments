class PeopleController < ApplicationController
  def show
    @membership_fees  = MembershipFee.where(person_id: params[:id])
    @donations        = Donation.where(person_id: params[:id])
    @organization     = Organization.find(100) 
  end
end
