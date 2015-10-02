class VotesController < ApplicationController
  def new_up_vote
    @proposal = Proposal.find_by_unique_token(params[:token])
    @up_vote = @proposal.votes.new
  end
    
  def cast_up_vote
    unless request.bot?
      @proposal = Proposal.find(params[:proposal_id])
      @ratified = Vote.up_vote!(@proposal, security_token, params[:body])
    else
      redirect_to '/404'
    end
  end
  
  def down_vote
    unless request.bot?
      @proposal = Proposal.find_by_unique_token(params[:token])
      Vote.down_vote!(@proposal, security_token)
    end
  end
end
