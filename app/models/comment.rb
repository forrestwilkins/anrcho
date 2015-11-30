class Comment < ActiveRecord::Base
  belongs_to :proposal
  belongs_to :comment
  belongs_to :vote
  
  has_many :comments
  has_many :hashtags
  
  validates_presence_of :body
  
  before_create :gen_unique_token
  
  def self.delete_all_old
    delete_all "created_at < '#{1.week.ago}'"
  end
  
  def replies
    self.comments
  end
  
  private
  
  def gen_unique_token
    self.unique_token = SecureRandom.urlsafe_base64
  end
end
