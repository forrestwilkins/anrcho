class Comment < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :comment
  has_many :comments
  has_many :hashtags
  validates_presence_of :body
  
  before_create :gen_unique_token
  
  def replies
    self.comments
  end
  
  private
  
  def gen_unique_token
    self.unique_token = SecureRandom.urlsafe_base64
  end
end
