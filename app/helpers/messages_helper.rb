module MessagesHelper
  def decrypt_message message
    key = if message.group
      message.group.token
    else
      message.token + message.receiver_token
    end
		key = ActiveSupport::KeyGenerator.new(key).generate_key(message.salt)
		encryptor = ActiveSupport::MessageEncryptor.new(key)
    message = encryptor.decrypt_and_verify(message.body)
    return message
  end
end
