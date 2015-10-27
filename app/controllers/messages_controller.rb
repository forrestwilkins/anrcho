class MessagesController < ApplicationController
  def add_image
  end
  
  def new_chat
    @group = Group.find_by_token(cookies[:last_chat_token]) \
      if cookies[:last_chat_token]
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
  
  def create
    @new_message = Message.new # for ajax, new form
    @group = Group.find_by_token params[:group_token]
    @message = Message.new(params[:message].permit(:body))
    @message.receiver_token = params[:receiver_token]
    @message.group_token = params[:group_token]
    @message.token = security_token
    if @message.save
      unless @group
        # notification to go here
        redirect_to secret_chat_path(params[:receiver_token])
      end
    else
      redirect_to :back unless @group
    end
  end
  
  def index
    @new_message = Message.new
    @receiver_token = params[:receiver_token]
    @group = Group.find_by_token(params[:group_token])
    if params[:group_token] and @group
      cookies.permanent[:last_chat_token] = @group.token
      set_last_im @group; @messages ||= @group.messages.last 5
    elsif @receiver_token.present?
      @messages = Message.between security_token, @receiver_token
    end
  end
  
  private
  
  # keeps track of last message loaded
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
