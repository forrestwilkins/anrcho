module VotesHelper
  def recently_up_voted? proposal
    vote = proposal.up_votes.find_by_token(security_token)
    return (up_voted? proposal and vote.created_at > 1.hour.ago)
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
