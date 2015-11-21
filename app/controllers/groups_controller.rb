class GroupsController < ApplicationController
  def toggle_manifesto
    @group = Group.find_by_token params[:group_token]
    cookies.permanent["group_#{@group.token}_manifesto_tip"] = true
    @manifesto = @group.manifestos.last
  end
  
  def manifestos
    @group = Group.find_by_token params[:group_token]
    @proposed_manifestos = @group.proposed_manifestos
  end
  
  def index
    # a list of all groups viewed so far
    views = View.where(token: security_token).where.not(group_token: nil)
    @groups = []; for view in views
      @groups << view.group unless @groups.include? view.group
    end
    @groups.reverse!
  end
  
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new
    if @group.save
      if params[:hashtags]
        Hashtag.add_from params[:hashtags], @group
      end
      if params[:local]
        set_location @group
      end
      redirect_to group_path(@group.token)
    else
      redirect_to :back
    end
  end
  
  def show
    reset_page
    @is_a_token = (params[:id].size > 5) ? true : false
    @group = Group.find_by_token(params[:id])
    unless @group.nil? or @group.expires?
      build_proposal_feed :all, @group
      @group.seent security_token
      @group_shown = true
    else
      redirect_to "/404"
    end
  end
end
