class Message < ActiveRecord::Base
  belongs_to :group
  before_create :encrypt_message
  validate :has_content
  
  mount_uploader :image, ImageUploader
  
  def encrypt_message
    if self.body.present? and self.group
      self.salt = SecureRandom.random_bytes(64)
      key = ActiveSupport::KeyGenerator.new(self.group.token).generate_key(self.salt)
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