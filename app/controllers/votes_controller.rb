class VotesController < ApplicationController  
  def up_vote
    unless request.bot?
      @proposal = Proposal.find_by_unique_token(params[:token])
      @ratified = Vote.up_vote!(@proposal, security_token)
    end
  end
  
  def down_vote
    unless request.bot?
      @proposal = Proposal.find_by_unique_token(params[:token])
      Vote.down_vote!(@proposal, security_token)
    end
  end
end
