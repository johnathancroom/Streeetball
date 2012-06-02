require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :password, :username, :email, :email_confirmed, :bio, :local_avatar, :dribbble_username, :twitter_username, :location, :crop_x, :crop_y, :crop_w, :crop_h
  
  avatar_styles = {
    :large => ['384x384#'],
    :small => ['100x100#']
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
    :default_url => "https://s3.amazonaws.com/#{ENV['S3_BUCKET']}/default_profile_image.jpeg",
    :styles => avatar_styles,
    :processors => [:cropper]
  
  attr_accessor :password
  before_save :encrypt_password
  
  before_create { generate_token(:auth_token) }
  
  has_many :posts
  has_many :likes
  has_many :comments
  
  validates_presence_of :username, :email
  validates_presence_of :password, :on => :create # Password only required during signup
  validates_uniqueness_of :username, :email, :case_sensitive => false
  
  validates :username, :format => { :with => /(\w|-|_)+\z/, :message => 'can only contain letters, numbers, underscores, and dashes' } # Username only alphanumeric + underscores/dashes
  
  # Use username instead of ID
  # http://stackoverflow.com/a/7735324/1136307
  def to_param
    username
  end
  
  # Auth
  def self.authenticate(person, password)
    if user = where("lower(email) = lower(?)", person).first || user = where("lower(username) = lower(?)", person).first # check username or email
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
  
  # Reset password
  def send_password_reset
    generate_token(:password_reset_token)
    save!
    UserMailer.password_reset(self).deliver
  end
  
  # Email Confirmation
  def send_email_confirmation
    generate_token(:email_confirmation_token)
    save!
    UserMailer.welcome_email(self).deliver
  end
  
  # Generate auth_token
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
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