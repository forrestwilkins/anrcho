class Group < ActiveRecord::Base
  has_many :hashtags
  has_many :proposals
  has_many :messages
  before_save :generate_token
  
  def expires?
    if self.created_at.to_date < 1.week.ago
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
