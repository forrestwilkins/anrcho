class Proposal < ActiveRecord::Base
  belongs_to :manifesto
  belongs_to :proposal
  belongs_to :group
  
  has_many :proposals
  has_many :comments
  has_many :hashtags
  has_many :votes
  
  before_create :gen_unique_token
  validates_presence_of :body
  
  scope :main, -> { where requires_revision: [nil, false] }
  scope :globals, -> { where(group_id: nil).where.not action: :revision }
  scope :voting, -> { where(ratified: [nil, false]).where requires_revision: [nil, false] }
  scope :revision, -> { where requires_revision: true }
  scope :ratified, -> { where ratified: true }
  
  mount_uploader :image, ImageUploader
  
  def evaluate
    if ratifiable?
      self.ratify!
      return true
    elsif requires_revision?
      self.update requires_revision: true
      Note.notify :proposal_blocked, self
      return nil
    end
  end
  
  def ratify!
    # for revision proposals
    if self.proposal
      case action.to_sym
      when :revision
        Note.notify :proposal_revised, self
        self.proposal.votes.destroy_all
        self.proposal.update(
          requires_revision: false,
          action: self.revised_action,
          title: self.title,
          body: self.body
        )
      end
    # proposals to groups
    elsif self.group
      case action.to_sym
      when :add_hashtags
        Hashtag.add_from self.misc_data, self.group
      when :add_locale
        self.group.set_location self.misc_data
      when :disband_early
        self.group.destroy!
      when :update_banner
        Banner.create(
          group_token: self.group.token,
          image: self.image
        )
      when :update_manifesto
        Manifesto.create(
          group_token: self.group.token,
          body: self.body
        )
      when :postpone_expiration
      when :change_ratification_threshold
      end
    # global proposals
    else
      case action.to_sym
      when :update_manifesto
        Manifesto.create body: self.body
      when :meetup
      end
    end
    self.update ratified: true
    Note.notify :ratified, self
    puts "\nProposal #{self.id} has been ratified.\n"
    self.tweet unless ENV['RAILS_ENV'].eql? 'development'
  end
  
  def tweet
    message = ""
    insert = lambda { |char| message << char if message.size < 140 }
    # inserts title into message
    self.title.split("").each do |char|
      insert.call char
    end
    insert.call " "
    # inserts body, breaks at hashtags
    self.body.split("").each do |char|
      break if char.eql? '#'
      insert.call char
    end
    insert.call " "
    # inserts tags if room
    self.hashtags.each do |tag|
      break unless tag.tag.size + message.size < 140
      tag.tag.split("").each do |char|
        insert.call char
      end
      insert.call " "
    end
    # checks in case api keys aren't present
    if ENV['TWITTER_CONSUMER_KEY'].present?
      $twitter.update message
    else
      puts "Twitter API keys are not present."
    end
  end
  
  def rank
    proposals = self.group.present? ? self.group.proposals : Proposal.globals
    ranked = proposals.sort_by { |proposal| proposal.score }
    return ranked.reverse.index(self) + 1 if ranked.include? self
  end
  
  def score
    Vote.score(self)
  end
  
  def self.action_types
    { request_feature: "A new feature",
      meetup: "Plan a local meetup",
      bug_fix: "A fix to a bug",
      update_manifesto: "A new manifesto",
      general: "A general statement or idea",
      just_a_test: "A test proposal" }
  end
  
  def self.group_action_types
    { add_hashtags: "Add hashtags",
      update_banner: "Propose a group banner",
      add_locale: "Set your locale as the groups",
      disband_early: "Disband, effective immediately",
      postpone_expiration: "Postpone expiration of the group",
      change_ratification_threshold: "Change ratification threshold",
      update_manifesto: "Propose a group manifesto" }
  end
  
  def votes_to_ratify
    self.ratification_threshold - self.verified_up_votes.size
  end
  
  def requires_revision?
    return self.down_votes.size > 0
  end
  
  def ratifiable?
    !self.ratified and self.down_votes.size.zero? \
      and self.verified_up_votes.size > self.ratification_threshold
  end
  
  def ratification_threshold
    _threshold = 10
    _views = if self.group
      self.group.views
    else
      self.views
    end
  	if _views.size > _threshold
  		return _views.size / 2
  	else
  		return _threshold / 2
  	end
  end
  
  def verified_up_votes
    self.up_votes.where verified: true
  end
  
  def verified_down_votes
    self.down_votes.where verified: true
  end
  
  def up_votes
    self.votes.up_votes
  end
  
  def down_votes
    self.votes.down_votes
  end
  
  def seent current_token
    unless self.seen? current_token
      self.views.create token: current_token
    end
  end
  
  def seen? current_token
    if self.views.find_by_token current_token
      return true
    else
      return false
    end
  end
  
  def views
    View.where proposal_token: self.unique_token
  end
  
  private
  
  def gen_unique_token
    self.unique_token = SecureRandom.urlsafe_base64
  end
end
