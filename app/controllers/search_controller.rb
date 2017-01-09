class SearchController < ApplicationController
  def locales
    @locales = View.locales.last(10).reverse
  end
  
  def broadcast_locale
    locale = get_location # returns as a hash
    @view = View.new token: security_token, location: locale[:address],
      latitude: locale[:lat], longitude: locale[:lon]
    if @view.location.present? and not View.locales.where(token: security_token).present? and @view.save
      redirect_to locales_path
    else
      redirect_to :back
    end
  end
  
  def toggle_menu
    # if nav menu is already open and was opened in the last 10 seconds
    if session[:nav_menu_shown].present? and session[:nav_menu_shown_at].to_datetime > 10.second.ago
      @nav_menu_shown = true
      session[:nav_menu_shown] = ''
    else
      @nav_menu_shown = false
      session[:nav_menu_shown] = true
      session[:nav_menu_shown_at] = DateTime.current
    end
  end
  
  def new
  end
  
  def index
    @query = params[:query].present? ? params[:query] : session[:query]
    session[:query] = @query; @results = []; @results_shown = true
    # to display different result types found for each query
    @result_types = { group: 0, proposal: 0, vote: 0, comment: 0, manifesto: 0 }
    if @query.present?
      setup_messages_between # renders form or link to messages
      [Proposal, Vote, Comment, Group, Manifesto].each do |_class|
        _class.all.reverse.each do |item|; match = false
          # scans all text for query
          match = true if scan_text item, @query
          # scans comments for current item
          match = true if scan_comments item, @query
          # a case for keywords used
          case @query
          when "proposals", "Proposals", "motions", "Motions"
            match = true if _class.eql? Proposal
          when "votes", "Votes"
            match = true if _class.eql? Vote and item.body.present?
          when "comments", "Comments"
            match = true if _class.eql? Comment
          when "groups", "Groups"
            match = true if _class.eql? Group
          when "manifestos", "Manifestos", "manifesto", "Manifesto"
            match = true if _class.eql? Manifesto
          end
          # groups only show in search when hashtags are added
          match = false if item.is_a? Group and item.hashtags.empty?
          # group proposals follow the same logic
          match = false if item.is_a? Proposal and item.group and item.group.hashtags.empty?
          # and group votes follow the same logic as well
          match = false if item.is_a? Vote and item.proposal.group and item.proposal.group.hashtags.empty?
          if match
            @results << item
            @result_types[item.class.to_s.downcase.to_sym] +=1
          end
        end
      end
      # removes any types not found at all, for display to view with/without commas
      @result_types.each { |key, val| @result_types.delete(key) if val.zero? }
    end
  end
  
  private
  
  def scan_comments item, query, match=false
    if item.respond_to? :comments
      item.comments.each do |comment|
        match = true if scan_text comment, query
        break if match
      end
    end
    return match
  end
  
  def scan_text item, query, match=false
    [:body, :token, :unique_token, :action, :location].each do |sym|
      if item.respond_to? sym and item.send(sym).present? 
        match = true if scan item.send(sym), query
      end
      break if match
    end
    match = true if scan_tags item, query
    return match
  end
  
  def scan_tags item, query, match=false
    if item.respond_to? :hashtags
      item.hashtags.each do |tag|
        if query.eql? tag.tag or "##{query}".eql? tag.tag
          match = true
        end
        break if match
      end
    end
    return match
  end
  
  def scan text, query, match=false
    for word in text.split(" ")
      for key_word in query.split(" ")
        if key_word.size > 2
          if word == key_word or word == key_word.downcase or word == key_word.capitalize \
            or word.include? key_word or word.include? key_word.downcase or word.include? key_word.capitalize
            match = true
          end
        end
        break if match
      end
    end
    return match
  end
  
  def setup_messages_between
    # to render direct message form in search
    # or link to messages already between users
    [Proposal, Comment, View, Vote].each do |_class|
      if security_token != @query
        if _class.find_by_token(@query)
          @new_message = Message.new
          @receiver_token = @query
          @last_between = Message.between(security_token,
            @receiver_token).last
          break
        end
      end
    end
  end
end
