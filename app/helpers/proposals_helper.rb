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
    proposal.up_votes.where(token: security_token).present?
  end
  
  def down_voted? proposal
    proposal.down_votes.where(token: security_token).present?
  end
end
