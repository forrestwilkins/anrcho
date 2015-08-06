class Note < ActiveRecord::Base
  def self.notify! item, action
    self.create receiver_token: item.token, action: action
  end
end
