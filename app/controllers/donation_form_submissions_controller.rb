class DonationFormSubmissionsController < ApplicationController

  protect_from_forgery with: :null_session
  skip_before_action :authenticate_person!, only: :create

  def create
    @donation_form_submission = DonationFormSubmission.create(params: params)
    render text: "Created", status: :created
  end

  def index
    @donation_form_submissions = DonationFormSubmission.accessible_by(current_ability)
  end

  def show
    @donation_form_submission = DonationFormSubmission.accessible_by(current_ability).find(params[:id])
  end

end
