require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :password, :username
  
  validates_presence_of :username, :password_hash
  
  # Remove dashes from username
  def username
    @username
  end
  def username=(value)
    @username = value.gsub(" ", "-")
  end
  
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
