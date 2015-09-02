class ProposalsController < ApplicationController
  def add_image
  end
  
  def index
    redirect_to '/404' if request.bot?
    if cookies[:loads].to_i < 5
      @loading = true
    end
    build_feed :all
  end
  
  def new
    @proposal = Proposal.new
    @parent_proposal = Proposal.find_by_id(params[:proposal_id])
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
      if @proposal.proposal
        redirect_to proposal_path(id: @proposal.proposal_id, revisions: true)
      elsif @proposal.group
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
    @group = @proposal.group
    if @proposal.present?
      @proposal_shown = true
      @up_votes = @proposal.up_votes
      @down_votes = @proposal.down_votes
      if params[:revisions]
        @revisions = @proposal.proposals
        @revision = Proposal.new
      else
        @comments = @proposal.comments
        @comment = Comment.new
      end
    else
      redirect_to '/404'
    end
  end
  
  def up_vote
    unless request.bot?
      @proposal = Proposal.find(params[:id])
      @ratified = Vote.up_vote!(@proposal, security_token)
    end
  end
  
  def down_vote
    unless request.bot?
      @proposal = Proposal.find(params[:id])
      Vote.down_vote!(@proposal, security_token)
    end
  end
  
  # Proposal sections: :voting, :revision, :ratified
  def switch_section
    build_feed params[:section]
  end
  
  private
  
  def build_feed section
    build_proposal_feed section
  end
  
  def build_action
    action = params[:proposal][:action]
    action = params[:proposal_action] unless action.present?
    case (action.present? ? action : "").to_sym
    when :add_locale, :meetup
      @proposal.misc_data = request.remote_ip.to_s
    when :revision
      @proposal.action = "revision"
      @proposal.proposal_id = params[:proposal_id]
    end
  end
  
  def proposal_params
    params[:proposal].permit(:title, :body, :action, :image, :misc_data)
  end
end
