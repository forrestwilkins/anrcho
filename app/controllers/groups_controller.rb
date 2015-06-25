class GroupsController < ApplicationController
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(params[:group])
    if @group.save
      if params[:local]
        get_location @group
      end
      redirect_to group_path(@group.token)
    else
      redirect_to :back
    end
  end
  
  def show
    reset_page
    @group = Group.find_by_token(params[:id])
    unless @group.nil? or @group.expires?
      @all_items = @group.proposals.sort_by { |proposal| proposal.rank }
      @items = paginate @all_items
    else
      @expired = true
    end
  end
end
