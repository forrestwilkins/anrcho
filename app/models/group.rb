# Group has the only table that doesn't use a 'unique_token'
# but it's own unique 'token' as it represents a distinct yet
# temporary identity just as any user does

class Group < ActiveRecord::Base
  has_many :hashtags
  has_many :proposals
  has_many :messages
  before_save :generate_token,
    :generate_passphrase
  
  def proposed_manifestos
    self.proposals.where(action: :update_manifesto)
  end
  
  def manifestos
    Manifesto.where group_token: self.token
  end
  
  def current_banner
    banner = self.banners.last
    return banner.image if banner
  end
  
  def banners
    Banner.where group_token: self.token
  end
  
  def expires?
    if self.expires_at.nil? and self.created_at.to_date < 1.week.ago
      self.destroy!
      return true
    else
      return false
    end
  end
  
  def set_location ip
    geoip = GeoIP.new('GeoLiteCity.dat').city(ip.to_s)
    if defined? geoip and geoip
      self.update latitude: geoip.latitude, longitude: geoip.longitude
      if self.latitude and self.longitude
        geocoder = Geocoder.search("#{self.latitude}, #{self.longitude}").first
        if geocoder and geocoder.formatted_address
          self.update location: geocoder.formatted_address
        end
      end
    end
  end
  
  def seent current_token
    unless self.seen? current_token
      self.views.create token: current_token
    end
  end
  
  def seen? current_token
    if self.views.find_by_token current_token
      return true
    else
      return false
    end
  end
  
  def views
    View.where group_token: self.token
  end
  
  private
  
  def generate_passphrase
    pass = Passphrase::Passphrase.new(  
      number_of_words: 4, languages: ["english"]
    )
    self.passphrase = pass.passphrase
  end
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
  
  def to_param
    token
  end
end
