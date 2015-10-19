module ProposalsHelper
  def action_types group=nil
		actions = [["Action to be proposed", nil]]
    actions_hash = group ? Proposal.group_action_types : Proposal.action_types
		actions_hash.each do |key, val|
      actions << [val, key.to_s]
    end
    return actions
  end
end
