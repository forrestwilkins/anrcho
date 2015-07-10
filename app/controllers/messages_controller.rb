class MessagesController < ApplicationController
  def new_chat
    @group = Group.new
    if @group.save
      redirect_to chat_path(@group.token)
    else
      redirect_to :back
    end
  end
  
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
    message_id = if instant_messages.present?
      instant_messages.last.id
    elsif group.messages.present?
      group.messages.last.id
    else
      nil
    end
    cookies[:last_im] = { message_id: message_id,
      group_token: group.token }.to_s
  end
end
