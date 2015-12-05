class View < ActiveRecord::Base
  validates_presence_of :token
  
  def self.delete_all_old
    delete_all "created_at < '#{1.week.ago}'"
  end
  
  def proposal
    Proposal.find_by_unique_token self.proposal_token
  end
  
  def group
    Group.find_by_token self.group_token
  end
end
