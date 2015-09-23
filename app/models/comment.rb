class Comment < ActiveRecord::Base
  belongs_to :proposal
  has_many :hashtags
  validates_presence_of :body
  
  before_create :gen_unique_token
  
  private
  
  def gen_unique_token
    self.unique_token = SecureRandom.urlsafe_base64
  end
end
