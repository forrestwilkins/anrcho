class Group < ActiveRecord::Base
  has_many :hashtags
  has_many :proposals
  before_save :generate_token
  
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
