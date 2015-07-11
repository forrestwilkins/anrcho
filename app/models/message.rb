class Message < ActiveRecord::Base
  belongs_to :group
  
  validates_presence_of :body
  
  before_create :encrypt_message
  
  mount_uploader :image, ImageUploader
  
  def encrypt_message
    if self.body.present? and self.group
      self.salt = SecureRandom.random_bytes(64)
      key = ActiveSupport::KeyGenerator.new(self.group.token).generate_key(self.salt)
      encryptor = ActiveSupport::MessageEncryptor.new(key)
      self.body = encryptor.encrypt_and_sign(self.body)
    end
  end
end
