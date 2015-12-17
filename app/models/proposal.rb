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
        new_version = self.proposal.dup
        new_version.assign_attributes({
          requires_revision: false,
          action: self.revised_action,
          version: self.version,
          title: self.title,
          body: self.body
        })
        if new_version.save
          self.proposal.update proposal_id: new_version.id
        end
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
        self.group.update expires_at: (Date.today + 14).to_s
      when :set_ratification_threshold
        self.group.update ratification_threshold: 25
      when :limit_views
        self.group.update view_limit: 3
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
    { general: "General statement or idea",
      direct_action: "Plan some direct action",
      cooperative: "Form a cooperative",
      meetup: "Local meetup",
      update_manifesto: "New manifesto",
      request_feature: "New feature",
      bug_fix: "Fix to a bug",
      just_a_test: "Test motion" }
  end
  
  def self.group_action_types
    { add_hashtags: "Add hashtags",
      update_banner: "Update group banner",
      add_locale: "Set your locale as the groups",
      disband_early: "Disband, effective immediately",
      postpone_expiration: "Postpone expiration of the group",
      set_ratification_threshold: "Set ratification threshold to 25",
      update_manifesto: "Update group manifesto",
      limit_views: "Expire at view limit of 3" }
  end
  
  def votes_to_ratify
    (self.ratification_threshold - self.verified_up_votes.size).to_i + 1
  end
  
  def requires_revision?
    return self.verified_down_votes.size > 0
  end
  
  def ratifiable?
    !self.ratified and self.verified_down_votes.size.zero? \
      and self.verified_up_votes.size > self.ratification_threshold
  end
  
  def ratification_threshold
    # dynamic threshold able to be set by group proposal
    _threshold = if self.group and self.group.ratification_threshold.present?
      self.group.ratification_threshold
    else
      5
    end
    # views for group if present
    _views = if self.group
      self.group.views
    else
      self.views
    end
    # uses views as threshold if higher
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
    self.votes.up_votes.where moot: [nil, false]
  end
  
  def down_votes
    self.votes.down_votes.where moot: [nil, false]
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
  
  def revisions
    self.proposals.where action: "revision"
  end
  
  # all proposals need to be updated as version 1 before this can work
  # unless database started with version 1 proposals by default
  def old_versions
    versions = self.proposals.where.not(action: "revision").
      where("version < '#{ self.version.to_i }'").sort_by do |version|
      version.version
    end
    return versions
  end
  
  private
  
  def gen_unique_token
    self.unique_token = SecureRandom.urlsafe_base64
  end
end
