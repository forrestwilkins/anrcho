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
  
  def create
    @new_message = Message.new # for ajax, new form
    @group = Group.find_by_token params[:group_token]
    @receiver_token = params[:receiver_token]
    @message = Message.new(params[:message].permit(:body))
    @message.receiver_token = @receiver_token
    @message.group_token = params[:group_token]
    @message.token = security_token
    if @message.save
      unless @group
        Note.notify :message_received, nil, @receiver_token, security_token
        redirect_to secret_chat_path(@receiver_token)
      end
    else
      redirect_to :back unless @group
    end
  end
  
  def index
    msg_limit = 4 # how many to display
    @new_message = Message.new
    @receiver_token = params[:receiver_token]
    @group = Group.find_by_token(params[:group_token])
    if params[:group_token] and @group
      cookies.permanent[:last_chat_token] = @group.token
      set_last_im @group; @messages ||= @group.messages.last msg_limit
    elsif @receiver_token.present?
      @messages = Message.between(security_token, @receiver_token).last msg_limit
    end
  end
  
  def instant_messages
    @group = Group.find_by_token(params[:token])
    @receiver_token = params[:token] unless @group
    @instant_messages = []
    # from group or secret chat between two users
    @messages = if @group
      @group.messages
    else
      Message.between security_token, params[:token]
    end
    for message in @messages
      @instant_messages << message if check_last_im(message)
    end
    set_last_im params[:token], @instant_messages
  end
  
  private
  
  def check_last_im message
    # eval to inflate hash from string
    puts "LAST IM: #{cookies[:last_im]}"
    in_sequence = false; last_im = eval(cookies[:last_im].to_s)
    if last_im.class.eql? Hash and message.id > last_im[:message_id].to_i
      if (@group and last_im[:group_token].eql? @group.token) \
        or (!@group and last_im[:receiver_token].eql? @receiver_token)
        in_sequence = true # meaning not the last message
      end
    end
    return in_sequence
  end
  
  # keeps track of last message loaded
  def set_last_im token=nil, instant_messages=nil
    message_id = if instant_messages.present?
      instant_messages.last.id
    # last message on page load, before ajax call
    elsif @group and @group.messages.present?
      @group.messages.last.id
    elsif @receiver_token and @messages.present?
      @messages.last.id
    else
      nil
    end
    last_im = { message_id: message_id }
    last_im[(@group.present? ? :group_token : :receiver_token)] = token
    cookies[:last_im] = last_im.to_s if last_im[:message_id]
  end
end
