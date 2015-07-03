class MessagesController < ApplicationController
  def instant_messages
    @instant_messages = Messsage.all
  end
  
  def create
    @group = Group.find_by_id params[:group_id]
    @message = @group.messages.new(params[:message].permit(:body)) if @group
    @message.token = security_token; @message.save if @message; redirect_to :back
  end
end
