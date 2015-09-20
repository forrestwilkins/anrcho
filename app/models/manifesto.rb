class Manifesto < ActiveRecord::Base
  has_many :proposals
  scope :proposed, -> { where ratified: [nil, false] }
  
  def group
    Group.find_by_token self.group_token
  end
end
