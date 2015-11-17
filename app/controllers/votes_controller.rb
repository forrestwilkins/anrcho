class VotesController < ApplicationController
  before_filter :bots_to_404
  
  def new_up_vote
    @proposal = Proposal.find_by_unique_token(params[:token])
    if @proposal and not @proposal.token.eql? security_token
      @up_vote = Vote.up_vote(@proposal, security_token)
    end
  end
  
  def new_down_vote
    @proposal = Proposal.find_by_unique_token(params[:token])
    if @proposal and not @proposal.token.eql? security_token
      @down_vote = Vote.down_vote(@proposal, security_token)
    end
  end
   
  def cast_up_vote
    @proposal = Proposal.find_by_unique_token(params[:token])
    @up_vote = Vote.up_vote(@proposal, security_token, params[:body])
    Hashtag.extract @up_vote
  end
  
  def cast_down_vote
    @proposal = Proposal.find_by_unique_token(params[:token])
    @down_vote = Vote.down_vote(@proposal, security_token, params[:body])
    Hashtag.extract @down_vote
  end
  
  def reverse
    @vote = Vote.find_by_unique_token params[:token]
    if @vote.down? and @vote.verified
      
    end
    redirect_to :back
  end
  
  def verify
    if cookies[:simple_captcha_validated].present?
      @vote = Vote.find_by_unique_token params[:token]
      if @vote.verifiable? security_token
        @vote.update verified: true
        @vote.proposal.evaluate
      end
    end
    redirect_to :back
  end
  
  def confirm_humanity
    if simple_captcha_valid?
      cookies.permanent[:simple_captcha_validated] = true
    end
    redirect_to :back
  end
  
  def show
    @vote = Vote.find_by_unique_token params[:token]
  end
  
  private
  
  def bots_to_404
    redirect_to '/404' if request.bot?
  end
end
