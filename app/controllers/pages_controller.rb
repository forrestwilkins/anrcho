class PagesController < ApplicationController
  def high_data
    cookies.permanent[:low_data] = ""
    redirect_to root_url
  end
  
  def low_data
    cookies.permanent[:low_data] = true
    redirect_to root_url
  end
  
  def fib
    @loading = false
    cookies.permanent[:loads] = "0"
    cookies.permanent[:low_data] = ""
    cookies.permanent[:last_im] = ""
    redirect_to root_url
  end
  
  def finish_loading
    View.delete_all_old
    cookies.permanent[:loads] = (cookies[:loads].to_i + 1).to_s
    build_proposal_feed :all
  end
  
  def more
    redirect_to '/404' if request.bot?
    cookies.permanent[:human] = true # humans wants more
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
    # 'sees' any unseen proposals being loaded
    if @items.present? and not @items.empty?
      for item in @items
        item.seent security_token if probably_human
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
