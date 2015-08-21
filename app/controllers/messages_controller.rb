class MessagesController < ApplicationController
  def add_image
  end
  
  def new_chat
    @group = Group.find_by_token(cookies[:last_chat_token]) if cookies[:last_chat_token]
    @group = Group.new if @group.nil? or @group.expires?
    if @group and @group.token
      redirect_to chat_path(@group.token)
    elsif @group.save
      cookies.permanent[:last_chat_token] = @group.token
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
    cookies.permanent[:last_chat_token] = @group.token
    set_last_im @group; @messages ||= @group.messages.last 5
    @new_message = Message.new
  end
  
  def create
    @new_message = Message.new
    @group = Group.find_by_id params[:group_id]
    @message = @group.messages.new(params[:message].permit(:body, :image)) if @group
    @message.token = security_token; @message.save if @message
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
