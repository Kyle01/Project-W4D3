class User < ApplicationRecord 
  validates :username, presence: true, uniqueness: true 
  validates :password_digest, presence: true 
  validates :session_token, presence: true, uniqueness: true 
  
  after_initialize :ensure_session_token 
  
  
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end
  
  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
    return nil
  end
  
  def is_password?(password)
    # BCrypt::Password.new(password) == self.password_digest
    BCrypt::Password.new(self.password_digest).is_password?(password)
   end 
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(username: user_name)
    return nil unless user
    user.is_password?(password) ? user : nil
  end


end 
