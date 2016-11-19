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
    if @vote.could_be_reversed? security_token
      @vote.votes.create flip_state: 'down', token: security_token
      if @vote.votes_to_reverse <= 0
        if @vote.up?
          @vote.proposal.update ratified: false
        elsif @vote.down?
          @vote.proposal.update requires_revision: false
        end
        @vote.update verified: false
        @vote.votes.destroy_all
      end
    end
    redirect_to :back
  end
  
  def verify
    if cookies[:simple_captcha_validated].present?
      @vote = Vote.find_by_unique_token params[:token]
      if @vote.verifiable? security_token and not @vote.proposal.requires_revision
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
    @comments = @vote.comments
    @new_comment = Comment.new
  end
  
  private
  
  def bots_to_404
    redirect_to '/404' if request.bot?
  end
end
