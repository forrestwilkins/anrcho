class TokenController < ApplicationController
  def update
    cookies.permanent[:token] = SecureRandom.urlsafe_base64
    cookies.permanent[:token_birthdate] = Date.today
    @token = cookies[:token]
  end
  
  def index
    @red = nil
    @green = nil
    @blue = nil
  end
end
