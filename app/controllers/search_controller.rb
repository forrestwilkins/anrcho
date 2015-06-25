class SearchController < ApplicationController
  def new
  end
  
  def index
    @query = params[:query].present? ? params[:query] : session[:query]
    session[:query] = @query; @results = []
    if @query.present?
      [Proposal, Comment, Group].each do |_class|
        _class.all.each do |item|
          match = false
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
end
