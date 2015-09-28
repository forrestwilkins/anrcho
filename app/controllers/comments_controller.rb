class CommentsController < ApplicationController
  def show
    @comment = Comment.find(params[:id])
    @replies = @comment.replies
    @reply = Comment.new
  end
  
  def new
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
      Note.notify :commented, @proposal if @proposal
      Hashtag.extract @comment
      if params[:proposal_shown] or params[:comment_id]
        redirect_to :back
      end
    end
  end
end
