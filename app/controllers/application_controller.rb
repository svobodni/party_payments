class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_person!
  before_filter :load_organizations

  rescue_from CanCan::AccessDenied, :with => :authorization_error

  def load_organizations
  	@organizations = Organization.order(:id).all
  	@organization = Organization.find(params[:organization_id]) if params[:organization_id]
  end

  def authenticate_person!
    redirect_to "/auth/registr" unless current_user
  end

  def current_user
    session[:person]
  end
  helper_method :current_user

end
