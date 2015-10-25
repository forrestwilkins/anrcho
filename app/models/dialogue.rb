class Dialogue < ActiveRecord::Base
  before_save :generate_token
  
  def find_between sender, receiver
    
  end
  
  private
  
  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end
