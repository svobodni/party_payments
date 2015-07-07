class DonationFormSubmissionsController < ApplicationController

  protect_from_forgery with: :null_session
  skip_before_action :authenticate_person!

  def create
    @donation_form_submission = DonationFormSubmission.create(params: params)
    render text: "Created", status: :created
  end

end
