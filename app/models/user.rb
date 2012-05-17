require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :password, :username, :email, :email_confirmed, :bio, :local_avatar, :dribbble_username, :twitter_username, :location, :crop_x, :crop_y, :crop_w, :crop_h
  
  avatar_styles = {
    :large => ['384x384>'],
    :small => ['100x100>']
  }
  has_attached_file :local_avatar,
    :styles => avatar_styles,
    :processors => [:cropper]
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  before_save :reprocess_avatar, :if => :cropping?
  
  has_attached_file :avatar,
    :storage => :s3, 
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :bucket => ENV['S3_BUCKET'],
    :s3_permissions => :public_read,
    :path => ':username/avatar_:style.:extension',
    :styles => avatar_styles,
    :processors => [:cropper]
  
  attr_accessor :password
  before_save :encrypt_password
  
  has_many :posts
  has_many :likes
  has_many :comments
  
  validates_presence_of :username, :email
  validates_presence_of :password, :unless => [:update]
  validates_uniqueness_of :username, :email, :case_sensitive => false
  
  # Use username instead of ID
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
  
  # Avatar Upload Cropping
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  def reprocess_avatar
    local_avatar.reprocess!
    self.avatar = local_avatar.to_file
    self.local_avatar = nil
  end
  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(local_avatar.to_file(style))
  end
end