class View < ActiveRecord::Base
  validates_presence_of :token, :proposal_token
  
  def proposal
    Proposal.find_by_unique_token self.proposal_token
  end
end
