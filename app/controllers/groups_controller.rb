class GroupsController < ApplicationController
  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(params[:group])
    if @group.save
      if params[:hashtags]
        params[:hashtags].split(" ").each do |tag|
          next unless tag.size > 1
          tag = "#" + tag unless tag.include? "#"
          tag.slice!(",") if tag.include? ","
          @group.hashtags.create(tag: tag)
        end
      end
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
    @is_a_token = (params[:id].size > 5) ? true : false
    @group = Group.find_by_token(params[:id])
    unless @group.nil? or @group.expires?
      @all_items = @group.proposals.sort_by { |proposal| proposal.rank }
      @items = paginate @all_items
      @group_shown = true
    else
      @expired = true
    end
  end
end
