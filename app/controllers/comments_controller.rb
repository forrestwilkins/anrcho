class CommentsController < ApplicationController
  def show
    @comment = Comment.find_by_unique_token(params[:token])
    @replies = @comment.replies
    @reply = Comment.new
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
    @comment = if @proposal
      @proposal.comments.new params[:comment].permit(:body)
    elsif @parent_comment
      @parent_comment.comments.new params[:comment].permit(:body)
    end
    @comment.token = security_token
    if @comment.save
      if @proposal
        Note.notify :commented, @proposal
      elsif @parent_comment
        Note.notify :replied, @parent_comment
      end
      Hashtag.extract @comment
      if params[:proposal_shown] or params[:comment_id]
        redirect_to :back
      end
    elsif params[:comment_id]
      redirect_to :back
    end
  end
end
