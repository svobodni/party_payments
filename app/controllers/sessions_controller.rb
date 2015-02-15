# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController
  def create
    session[:person]={
      id: auth_hash[:uid],
      name: auth_hash[:info][:name],
      info: auth_hash[:extra][:raw_info]
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
