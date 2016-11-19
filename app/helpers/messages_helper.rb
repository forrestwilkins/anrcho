module MessagesHelper
  def decrypt_message message
    key = if message.group
      message.group.token
    elsif message.token.eql? security_token \
      or message.receiver_token.eql? security_token
      message.token[0..10] + message.receiver_token[0..10]
    end
    if key
		  key = ActiveSupport::KeyGenerator.new(key).generate_key(message.salt)
		  encryptor = ActiveSupport::MessageEncryptor.new(key)
      message = encryptor.decrypt_and_verify(message.body)
      return message
    else
      return message.body
    end
  end
end
