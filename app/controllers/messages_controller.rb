class MessagesController < ApplicationController
  def instant_messages
    @group = Group.find_by_token(params[:token])
    @instant_messages = []
    for message in @group.messages
      @instant_messages << message
    end
    cookies[:last_message_id] = @instant_messages.last.id
  end
  
  def index
    @group = Group.find_by_token(params[:token])
    @messages ||= @group.messages
    @message = Message.new
  end
  
  def create
    @group = Group.find_by_id params[:group_id]
    @message = @group.messages.new(params[:message].permit(:body)) if @group
    @message.token = security_token; @message.save if @message; redirect_to :back
  end
end
