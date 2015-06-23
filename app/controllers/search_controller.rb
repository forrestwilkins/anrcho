class SearchController < ApplicationController
  def new
  end
  
  def index
    @query = params[:query].present? ? params[:query] : session[:query]
    session[:query] = @query; @results = []
    [Proposal, Comment, Group].each do |_class|
      _class.all.each do |item|
        item.hashtags.each do |tag|
          if @query.eql? tag.tag or "##{@query}".eql? tag.tag
            @results << item
          end
        end
        if @query.eql? item.token
          @results << item
        end
      end
    end
  end
end
