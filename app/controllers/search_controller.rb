class SearchController < ApplicationController
  def toggle_menu  
  end
  
  def new
  end
  
  def index
    @query = params[:query].present? ? params[:query] : session[:query]
    session[:query] = @query; @results = []; @results_shown = true
    if @query.present?
      [Proposal, Comment, Group, Manifesto].each do |_class|
        messages_between _class # link to existing messages or new form
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
          match = false if item.is_a? Group and item.hashtags.empty?
          @results << item if match
        end
      end
    end
  end
  
  private
  
  def messages_between _class
    # to render direct message form in search
    # or link to messages already between users
    if _class != Group and _class != Manifesto \
      and security_token != @query and _class.find_by_token(@query)
      @new_message = Message.new
      @receiver_token = @query
      @last_between = Message.between(security_token,
        @receiver_token).last
    end
  end
  
  def scan_text item, query, match=false
    if item.respond_to? :body
      match = true if scan item.body, query
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
