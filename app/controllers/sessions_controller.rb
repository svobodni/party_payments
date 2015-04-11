# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController
  skip_before_filter :authenticate_person!

  def create
    session[:person]={
      id: auth_hash[:uid],
      name: auth_hash[:info][:name],
      info: auth_hash[:extra][:raw_info],
      access_token: auth_hash[:info][:access_token],
      refresh_token: auth_hash[:info][:refresh_token]
    }
    redirect_to '/'
  end

  def destroy
    session[:person]=nil
    flash[:notice]="Byl jste úspěšně odhlášen"
    redirect_to '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
