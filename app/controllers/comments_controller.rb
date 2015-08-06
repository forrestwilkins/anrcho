class CommentsController < ApplicationController
  def new
    @proposal = Proposal.find(params[:proposal_id])
    @comment = @proposal.comments.new
  end
  
  def create
    @proposal = Proposal.find(params[:proposal_id])
    @comment = @proposal.comments.new params[:comment].permit(:body)
    @comment.token = security_token
    if @comment.save
      Hashtag.extract @comment
      if params[:proposal_shown]
        redirect_to :back
      end
    end
  end
end
