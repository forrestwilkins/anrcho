class Manifesto < ActiveRecord::Base
  has_many :proposals
  scope :proposed, -> { where ratified: [nil, false] }
end