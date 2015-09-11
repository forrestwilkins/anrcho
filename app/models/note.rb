class Note < ActiveRecord::Base
  before_create :write_message
  
  scope :unseen, -> { where seen: [nil, false] }
  
  def self.notify action, item, receiver=nil
    self.create(
      receiver_token: (receiver.nil? ? item.token : receiver),
      item_id: item.id,
      action: action
    )
  end
  
  def action_text action
    _actions = { ratified: "Your proposal has been ratified.",
      commented: "Someone commented on your proposal." }
    return _actions[action.to_sym]
  end
  
  private
  
  def write_message
    self.message = self.action_text self.action
  end
end
