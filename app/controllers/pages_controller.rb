class PagesController < ApplicationController
  def more
    relevant_items = if params[:proposals]
      Proposal.globals
    elsif params[:group_token]
      Group.find_by_token(params[:group_token]).proposals
    end
    if session[:page].nil? or session[:page] * page_size <= relevant_items.size
      if session[:page]
        session[:page] += 1
      else
        session[:page] = 1
      end
      build_feed_data
    end
  end
  
  private
  
  def build_feed_data
    if params[:proposals]
      @all_items = Proposal.globals.sort_by { |proposal| proposal.rank }
      @items = paginate @all_items
      @char_codes = char_codes @items
      @home_shown = true
    elsif params[:group_token]
      @group = Group.find_by_token(params[:group_token])
      @all_items = @group.proposals.sort_by { |proposal| proposal.rank }
      @items = paginate @all_items
      @group_shown = true
    end
  end
end
