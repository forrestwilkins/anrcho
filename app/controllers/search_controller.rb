class SearchController < ApplicationController
  def new
  end
  
  def index
    @query = params[:query].present? ? params[:query] : session[:query]
    session[:query] = @query; @results = []
    [Proposal, Comment, Group].each do |_class|
      _class.all.each do |item|
        # scans all items for matching tags
        item.hashtags.each do |tag|
          if @query.eql? tag.tag or "##{@query}".eql? tag.tag
            @results << item
          end
        end
        # searches by token or location
        if @query.eql? item.token or item.location.to_s.include? @query.to_s
          @results << item
        end
      end
    end
  end
end
