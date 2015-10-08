class TokenController < ApplicationController
  def update
    unless request.bot?
      timestamp = cookies[:ip_timestamp]
      if (timestamp.nil? or timestamp.to_datetime < 1.hours.ago) \
        and ENV['RAILS_ENV'].eql? 'development'
        cookies.permanent[:ip] = request.remote_ip.to_s
        cookies.permanent[:token] = SecureRandom.urlsafe_base64
        cookies.permanent[:ip_timestamp] = DateTime.current.to_s
        cookies.permanent[:token_timestamp] = DateTime.current.to_s
      end
      @token = cookies[:token]
    end
    redirect_to root_url
  end
  
  def index
    @red = nil
    @green = nil
    @blue = nil
  end
end
