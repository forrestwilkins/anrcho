module MessagesHelper
  def decrypt_message message
    key = if message.group
      message.group.token
    elsif message.token and message.receiver_token
      message.token[0..10] + message.receiver_token[0..10]
    end
		key = ActiveSupport::KeyGenerator.new(key).generate_key(message.salt)
		encryptor = ActiveSupport::MessageEncryptor.new(key)
    message = encryptor.decrypt_and_verify(message.body)
    return message
  end
end
