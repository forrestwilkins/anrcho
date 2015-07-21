class ProposalsController < ApplicationController
  def add_image
  end
  
  def index
    reset_page
    @all_items = Proposal.globals.voting.sort_by { |proposal| proposal.rank }
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
    build_action
    if @proposal.save
      if params[:local]
        set_location @proposal
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
  
  def build_action
    action = params[:proposal][:action]
    case (action.present? ? action : "").to_sym
    when :add_locale, :meetup
      @proposal.misc_data = request.remote_ip.to_s
    end
  end
  
  def proposal_params
    params[:proposal].permit(:title, :body, :action, :image, :misc_data)
  end
end
