class ProposalsController < ApplicationController
  def add_image
  end
  
  def index
    redirect_to '/404' if request.bot?
    if cookies[:loads].to_i.zero?
      @loading = true
    end
    build_feed :main
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
        Note.notify :revision_submitted, @proposal.proposal
        redirect_to show_proposal_path(token: @proposal.proposal.unique_token, revisions: true)
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
    @proposal = Proposal.find_by_unique_token(params[:token])
    @group = @proposal.group if @proposal
    if @proposal
      @proposal_shown = true
      @proposal.seent security_token
      @up_votes = @proposal.up_votes
      @down_votes = @proposal.down_votes
      if params[:votes]
        @show_votes = true
      elsif params[:revisions]
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
  
  # Proposal sections: :voting, :revision, :ratified
  def switch_section
    @group = Group.find_by_token params[:group_token]
    build_feed params[:section], @group
  end
  
  private
  
  def build_feed section, group=nil
    build_proposal_feed section, group
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
      @proposal.revised_action = params[:revised_action]
    end
  end
  
  def proposal_params
    params[:proposal].permit(:title, :body, :action, :image, :misc_data)
  end
end
