class VotesController < ApplicationController  
  def new_up_vote
    unless request.bot?
      @proposal = Proposal.find_by_unique_token(params[:token])
      if @proposal and not @proposal.token.eql? security_token
        @up_vote = Vote.up_vote(@proposal, security_token)
      end
    end
  end
    
  def cast_up_vote
    unless request.bot?
      @proposal = Proposal.find(params[:proposal_id])
      @up_vote = Vote.up_vote(@proposal, security_token, params[:body])
      @vote_cast = @up_vote.body.present?
    else
      redirect_to '/404'
    end
  end
  
  def down_vote
    unless request.bot?
      @proposal = Proposal.find_by_unique_token(params[:token])
      Vote.down_vote(@proposal, security_token)
    end
  end
  
  def verify
    @vote = Vote.find_by_unique_token params[:token]
    if @vote.verifiable? security_token
      @vote.update verified: true
    end
    redirect_to :back
  end
  
  def show
    @vote = Vote.find_by_unique_token params[:token]
  end
end
