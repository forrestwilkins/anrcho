class Group < ActiveRecord::Base
  has_many :hashtags
  has_many :proposals
  before_save :generate_token
  
  def get_location ip
    geoip = GeoIP.new('GeoLiteCity.dat').city(ip)
    if defined? geoip and geoip
      self.update latitude: geoip.latitude, longitude: geoip.longitude
      if self.latitude and self.longitude
        geocoder = Geocoder.search("#{self.latitude}, #{self.longitude}").first
        if geocoder and geocoder.formatted_address
          self.update location: geocoder.formatted_address
        end
        return true
      else
        return false
      end
    else
      return false
    end
  end
  
  def expires?
    unless self.created_at.to_date.eql? Date.today
      self.destroy!
      return true
    else
      return false
    end
  end
  
  private
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
  
  def to_param
    token
  end
end
