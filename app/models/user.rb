require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :password, :username, :email, :email_confirmation_code, :email_confirmed
  
  validates_presence_of :username, :password_hash
  
  # Encrypt password
  include BCrypt
  def password
    @password ||= Password.new(password_hash)
  end
  def password=(value)
    @password = Password.create(value)
    self.password_hash = @password
  end
end