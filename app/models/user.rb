class User < ActiveRecord::Base
  has_many :proposals
  has_many :comments
  has_many :messages
  has_many :votes
  has_many :notes, dependent: :destroy

  def update_token
    self.generate_token
    self.save
  end

  def gen_auth_token
    begin
      self.auth_token = SecureRandom.urlsafe_base64
    end while User.exists? auth_token: self.auth_token
  end

  def self.authenticate name, passphrase
    user = self.find_by_name name
    # if user found and passphrase matches decrypted one saved in db
    if user && user.passphrase == BCrypt::Engine.hash_secret(passphrase, user.salt)
      user
    else
      nil
    end
  end

  private
    def gen_unique_token
      self.token = SecureRandom.urlsafe_base64
    end

    def encrypt_password
      if self.passphrase.present?
        self.salt = BCrypt::Engine.generate_salt
        self.passphrase = BCrypt::Engine.hash_secret(self.passphrase, self.salt)
      end
    end
end
