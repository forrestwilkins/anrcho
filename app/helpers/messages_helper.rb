module MessagesHelper
  def decrypt_message(message)
		key = ActiveSupport::KeyGenerator.new(message.group.token).generate_key(message.salt)
		encryptor = ActiveSupport::MessageEncryptor.new(key)
    message = encryptor.decrypt_and_verify(message.body)
    return message
  end
end
