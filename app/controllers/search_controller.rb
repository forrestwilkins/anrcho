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
    if @query.present?
      setup_messages_between # renders form or link to messages
      [Proposal, Vote, Comment, Group, Manifesto].each do |_class|
        _class.all.reverse.each do |item|
          match = false; match_by_hashtag = false
          # searches by proposal type
          if item.is_a? Proposal and item.action \
            and scan item.action, @query
            match = true
          end
          # scans all text for query
          match = true if scan_text item, @query
          # scans all items for matching tags
          if item.respond_to? :hashtags
            item.hashtags.each do |tag|
              if @query.eql? tag.tag or "##{@query}".eql? tag.tag
                match_by_hashtag = true
                match = true
              end
            end
          end
          # searches by token
          if item.respond_to? :token and @query.eql? item.token
            match = true
          end
          # searches by location
          if item.respond_to? :location and item.location.to_s.include? @query.to_s
            match = true
          end
          match = false if (item.is_a? Group or item.is_a? Vote) and item.hashtags.empty?
          @results << item if match
        end
      end
    end
  end
  
  private
  
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
  
  def scan_text item, query, match=false
    if item.respond_to? :body
      match = true if item.body.present? and scan item.body, query
    end
    return match
  end
  
  def scan text, query, match=false
    for word in text.split(" ")
      for key_word in query.split(" ")
        if key_word.size > 2
          if word == key_word.downcase or word == key_word.capitalize \
            or word.include? key_word.downcase or word.include? key_word.capitalize
            match = true
          end
        end
      end
    end
    return match
  end
end
