class Message < ActiveRecord::Base
  belongs_to :group
  before_create :encrypt_message
  validate :has_content
  
  mount_uploader :image, ImageUploader
  
  def self.delete_all_old
    delete_all "created_at < '#{1.week.ago}'"
  end
  
  def group
    Group.find_by_token self.group_token
  end
  
  def self.between sender, receiver
    messages = []
    self.where(token: sender, receiver_token: receiver).each do |message|
      messages << message
    end
    self.where(token: receiver, receiver_token: sender).each do |message|
      messages << message
    end
    return messages.sort_by { |message| message.created_at }
  end
  
  def self.encrypt message, key
    encryptor = ActiveSupport::MessageEncryptor.new(key)
    message = encryptor.encrypt_and_sign(message)
    return message
  end
  
  def self.decrypt message, key
	  encryptor = ActiveSupport::MessageEncryptor.new(key)
    message = encryptor.decrypt_and_verify(message)
    return message
  end
  
  def encrypt_message
    if self.body.present?
      key = if self.group
        self.group.token
      elsif self.token and self.receiver_token
        # for direct messaging between 2 users
        self.token[0..10] + self.receiver_token[0..10]
        # uses half of both of their tokens as the key
      end
      self.salt = BCrypt::Engine.generate_salt
      key = ActiveSupport::KeyGenerator.new(key).generate_key(self.salt)
      encryptor = ActiveSupport::MessageEncryptor.new(key)
      self.body = encryptor.encrypt_and_sign(self.body)
    end
  end
  
  private
  
  def has_content
    if (self.body.nil? or self.body.empty?) and !self.image.url
      errors.add(:no_content, "Your message was void of content.")
    end 
  end
end
