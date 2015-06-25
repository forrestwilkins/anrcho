class ProposalsController < ApplicationController
  def add_image
  end
  
  def index
    reset_page
    @all_items = Proposal.globals.sort_by { |proposal| proposal.rank }
    @char_codes = char_codes @all_items
    @items = paginate @all_items
  end
  
  def new
    @proposal = Proposal.new
    @group = Group.find_by_id(params[:group_id])
  end
  
  def create
    @proposal = Proposal.new(proposal_params)
    @proposal.group_id = params[:group_id]
    @proposal.token = security_token
    if @proposal.save
      if params[:local]
        get_location @proposal  
      end    	
      Hashtag.extract @proposal
      if @proposal.group
        redirect_to group_path(@proposal.group.token)
      else
        redirect_to root_url
      end
    else
      redirect_to :back
    end
  end
  
  def show
    @proposal = Proposal.find_by_id(params[:id])
    @comments = @proposal.comments
    @comment = Comment.new
  end
  
  def up_vote
    @proposal = Proposal.find(params[:id])
    @ratified = Vote.up_vote!(@proposal, security_token)
  end
  
  def down_vote
    @proposal = Proposal.find(params[:id])
    Vote.down_vote!(@proposal, security_token)
  end
  
  private
  
  def proposal_params
    params[:proposal].permit(:title, :body, :action, :image)
  end
end
