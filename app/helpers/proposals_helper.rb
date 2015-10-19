module ProposalsHelper
  def action_types group=nil
		actions = [["Action to be proposed", nil]]
    actions_hash = group ? Proposal.group_action_types : Proposal.action_types
		actions_hash.each do |key, val|
      actions << [val, key.to_s]
    end
    return actions
  end
  
  def up_voted? proposal
    vote = proposal.up_votes.find_by_token(security_token)
    if vote and vote.body.present?
      return vote
    else
      return nil
    end
  end
  
  def down_voted? proposal
    proposal.down_votes.where(token: security_token).present?
  end
end
