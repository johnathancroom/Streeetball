require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :password, :username, :email, :email_confirmed, :bio, :image_url, :dribbble_username, :twitter_username, :location
  
  attr_accessor :password
  before_save :encrypt_password
  
  has_many :posts
  has_many :comments
  
  validates_presence_of :username, :email
  validates_presence_of :password, :unless => [:update]
  validates_uniqueness_of :username, :email, :case_sensitive => false
  
  # Use username insteaf of ID
  # http://stackoverflow.com/a/7735324/1136307
  def to_param
    username
  end
  
  # Auth
  def self.authenticate(person, password)
    if user = where("lower(email) = ?", person.downcase).first || user = where("lower(username) = ?", person.downcase).first # check username or email
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