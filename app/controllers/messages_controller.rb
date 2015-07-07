class MessagesController < ApplicationController
  def instant_messages
    @group = Group.find_by_token(params[:token])
    last_im = eval(cookies[:last_im].to_s)
    @instant_messages = []; for message in @group.messages
      @instant_messages << message if last_im.class.eql? Hash \
        and message.id > last_im[:message_id].to_i \
        and last_im[:group_token].eql? @group.token
    end
    set_last_im @group, @instant_messages
  end
  
  def index
    @group = Group.find_by_token(params[:token])
    set_last_im @group; @messages ||= @group.messages
    @message = Message.new
  end
  
  def create
    @group = Group.find_by_id params[:group_id]
    @message = @group.messages.new(params[:message].permit(:body)) if @group
    @message.token = security_token; @message.save if @message; redirect_to :back
  end
  
  private
  
  def set_last_im group, instant_messages=nil
    cookies[:last_im] = { message_id: (instant_messages.present? \
      ? instant_messages.last.id : group.messages.last.id),
      group_token: group.token }.to_s if group.messages.present?
  end
end
