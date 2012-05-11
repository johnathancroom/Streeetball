require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :password, :username, :email, :email_confirmed
  
  attr_accessor :password
  before_save :encrypt_password
  
  has_many :posts
  has_many :comments
  
  validates_presence_of :username, :password, :email
  validates_uniqueness_of :username, :email, :case_sensitive => false
  
  # Auth
  def self.authenticate(user, password)
    #user = find_by_email(user)
    if user = find_by_email(user) || user = find_by_username(user) # email or username
      if user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt) # check password
        user # return user
      end
    end
  end
  
  # Encrypt password
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end