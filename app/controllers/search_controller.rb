class SearchController < ApplicationController
  def toggle_menu  
  end
  
  def new
  end
  
  def index
    @query = params[:query].present? ? params[:query] : session[:query]
    session[:query] = @query; @results = []
    if @query.present?
      [Proposal, Comment, Group].each do |_class|
        _class.all.each do |item|
          match = false
          # scans all text for query
          match = scan_text item, @query
          # scans all items for matching tags
          item.hashtags.each do |tag|
            if @query.eql? tag.tag or "##{@query}".eql? tag.tag
              match = true
            end
          end
          # searches by token
          if @query.eql? item.token
            match = true
          end
          # searches by location
          if item.location.to_s.include? @query.to_s
            match = true
          end
          @results << item if match
        end
      end
    end
  end
  
  private
  
  def scan_text item, query, match=false
    if item.respond_to? :body
      for word in item.body.split(" ")
        for key_word in query.split(" ")
          if key_word.size > 2
            if word == key_word.downcase or word == key_word.capitalize
              match = true
            elsif word.include? key_word.downcase or word.include? key_word.capitalize
              match = true
            end
          end
        end
      end
    end
    return match
  end
end
