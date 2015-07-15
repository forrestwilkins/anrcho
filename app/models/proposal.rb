class Proposal < ActiveRecord::Base
  belongs_to :group
  belongs_to :manifesto
  has_many :votes
  has_many :comments
  has_many :hashtags
  validates_presence_of :body
  
  scope :globals, -> { where group_id: nil }
  scope :ratified, -> { where ratified: true }
  scope :revision, -> { where requires_revision: true }
  scope :voting, -> { where(ratified: [nil, false]).
    where requires_revision: [nil, false] }
  
  mount_uploader :image, ImageUploader
  
  def ratify!
    if ratifiable?
      unless self.group
        case action.to_sym
        when :meetup
          
        when :new_banner
          
        end
      else
        case action.to_sym
        when :add_hashtags
          
        when :add_locale
          
        when :disband_early
          
        when :postpone_expiration
          
        end
      end
      self.update ratified: true
      puts "\nProposal #{self.id} has been ratified.\n"
      return true
    elsif requires_revision?
      self.update requires_revision: true
      return nil
    end
  end
  
  def rank
    proposals = self.group.present? ? self.group.proposals : Proposal.globals
    ranked = proposals.sort_by { |proposal| proposal.score }
    return ranked.reverse.index(self) + 1
  end
  
  def score
    Vote.score(self)
  end
  
  def self.action_types
    { meetup: "Meetup locally", new_banner: "Set a new site banner" }
  end
  
  def self.group_action_types
    { add_hashtags: "Add hashtags",
        add_locale: "Set your locale as the groups",
        disband_early: "Disband earlier than specified",
        postpone_expiration: "Postpone expiration of the group" }
  end
  
  def ratified?
    self.ratified
  end
  
  def ratifiable?
    !self.ratified and self.up_votes.size >= _ratification_point \
      and self.down_votes.size < self.up_votes.size / 5.0
  end
  
  def requires_revision?
    self.up_votes.size >= _ratification_point \
      and self.down_votes.size > self.up_votes.size / 5.0
  end
  
  def _ratification_point
  	if self.ratification_point.to_i.zero?
  		return 3
  	else
  		return self.ratification_point
  	end
  end
  
  def up_votes
    self.votes.up_votes
  end
  
  def down_votes
    self.votes.down_votes
  end
end
