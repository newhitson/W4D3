class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :session_token, presence: true, uniqueness: true
  validates :password, length: {minimum: 6, has_nil: true}

  after_initialize :ensure_session_token

  attr_reader :password

  def self.reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(16)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(16)
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
    password_digest
  end

  def is_password?(password)
    BCrypt::Password.new(password).is_password?(self.password_digest)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by_username(:username)
    if user.nil?
      render :new
    else
      if is_password?(password)
      return username
      else
        render :new
      end
    end
  end

end
