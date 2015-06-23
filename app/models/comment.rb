class Comment < ActiveRecord::Base
  belongs_to :proposal
  has_many :hashtags
  validates_presence_of :body
end
