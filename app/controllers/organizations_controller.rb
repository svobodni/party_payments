class OrganizationsController < ApplicationController

  # GET /organizations
  # GET /organizations.json
  def index
    @organizations = Organization.all
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @organization = Organization.find(params[:id])
  end
end
