class PagesController < ApplicationController
  def finish_loading
    build_proposal_feed :all
    cookies.permanent[:loads] = (cookies[:loads].to_i + 1).to_s
  end
  
  def fib
    @loading = false
    cookies.permanent[:loads] = "0"
    redirect_to root_url
  end
  
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
      @all_items = current_proposals.sort_by { |proposal| proposal.rank }
      @items = paginate @all_items
      @char_codes = char_codes @items
      @home_shown = true
    elsif params[:group_token]
      @group = Group.find_by_token(params[:group_token])
      @all_items = @group.proposals.sort_by { |proposal| proposal.rank }
      @items = paginate @all_items
      @group_shown = true
    end
    if @items.present? and not @items.empty?
      for item in @items
        item.seent security_token
      end
    end
  end
  
  def current_proposals
    # only loads proposals from current section if a sections been chosen
    if session[:current_proposal_section].present?
      proposals = Proposal.globals.send(session[:current_proposal_section].to_sym)
    else
      # returns all if no currently chosen section
      proposals = Proposal.globals
    end
    return proposals
  end
end
