class CommentsController < ApplicationController
  def show
    @comment = Comment.find_by_unique_token(params[:token])
    if @comment.present?    
      @replies = @comment.replies
      @reply = Comment.new
    else
      redirect_to "/404"
    end
  end
  
  def new
    @commenting = true
    @proposal = Proposal.find_by_id(params[:proposal_id])
    @parent_comment = Comment.find_by_id(params[:comment_id])
    @new_comment = if @proposal
      @proposal.comments.new
    else
      @parent_comment.comments.new
    end
  end
  
  def create
    @proposal = Proposal.find_by_id(params[:proposal_id])
    @parent_comment = Comment.find_by_id(params[:comment_id])
    @vote = Vote.find_by_id(params[:vote_id]) # comments on votes
    @comment = if @proposal
      @proposal.comments.new comment_params
    elsif @parent_comment
      @parent_comment.comments.new comment_params
    elsif @vote
      @vote.comments.new comment_params
    end
    @comment.token = security_token
    if @comment.save
      if @proposal
        Note.notify :commented, @proposal \
          unless @proposal.token.eql? security_token
      elsif @parent_comment
        Note.notify :replied, @parent_comment \
          unless @parent_comment.token.eql? security_token
      elsif @vote
        Note.notify :commented_vote, @vote \
          unless @vote.token.eql? security_token
      end
      Hashtag.extract @comment
      if params[:proposal_shown] or params[:comment_id] or params[:vote_id]
        redirect_to :back
      end
    else
      redirect_to :back
    end
  end
  
  private
  
  def comment_params
    params[:comment].permit(:body)
  end
end
