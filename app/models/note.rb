class Note < ActiveRecord::Base
  before_create :write_message
  
  scope :unseen, -> { where seen: [nil, false] }
  
  def self.notify action, item=nil, receiver=nil, sender=nil
    self.create(
      receiver_token: (receiver.nil? ? item.token : receiver),
      item_token: (item.nil? ? sender : item.unique_token),
      action: action
    )
  end
  
  def action_text action
    _actions = { ratified: "Your proposal has been ratified.",
      proposal_blocked: "Someone blocked your proposal.",
      revision_submitted: "Someone proposed a revision to your proposal.",
      proposal_revised: "Your proposal has been revised.",
      commented_vote: "Someone commented on your vote.",
      commented: "Someone commented on your proposal.",
      also_commented: "Someone also commented on a proposal.",
      also_commented_vote: "Someone also commented on a vote.",
      replied: "Someone replied to your comment.",
      message_received: "You've received a message." }
    return _actions[action.to_sym]
  end
  
  private
  
  def write_message
    self.message = self.action_text self.action
  end
end
