class Note < ActiveRecord::Base
  before_create :write_message
  
  scope :unseen, -> { where seen: [nil, false] }
  
  def self.notify action, item, receiver=nil
    self.create(
      receiver_token: (receiver.nil? ? item.token : receiver),
      item_token: item.unique_token,
      action: action
    )
  end
  
  def action_text action
    _actions = { ratified: "Your proposal has been ratified.",
      proposal_blocked: "Someone blocked your proposal.",
      revision_submitted: "Someone proposed a revision to your proposal.",
      proposal_revised: "Your proposal has been revised.",
      commented: "Someone commented on your proposal.",
      replied: "Someone replied to your comment.",
      message_received: "You received a message." }
    return _actions[action.to_sym]
  end
  
  private
  
  def write_message
    self.message = self.action_text self.action
  end
end
