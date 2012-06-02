# Time limit validation
class TimeLimitValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    @last_post = Post.where("user_id = ? AND image_file_name != ''", value).last # Last uploaded image (ignore half-uploads)
    if !@last_post.nil? && @last_post.created_at.to_i > 24.hours.ago.to_i # Length between posts
      record.errors[:created_at] << 'Only one image can be posted every 24 hours.'
    end
  end
end

class Post < ActiveRecord::Base  
  attr_accessible :name, :user_id, :local_image, :image, :description, :crop_x, :crop_y, :crop_w, :crop_h
  
  image_styles = {
    :regular => ['400x300#'],
    :small => ['192x144#']
  }
  has_attached_file :local_image,
    :styles => image_styles,
    :processors => [:cropper]
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  before_save :reprocess_image, :if => :cropping?
  
  has_attached_file :image,
    :storage => :s3, 
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :bucket => ENV['S3_BUCKET'],
    :s3_permissions => :public_read,
    :path => ':post_username/:id/:basename_:style.:extension',
    :styles => image_styles,
    :processors => [:cropper]
  
  has_many :comments
  has_many :likes
  belongs_to :user
  
  validates_presence_of :name, :user_id
  validates_attachment_presence :local_image, :message => 'Image must be attached'
  validates :user_id, :time_limit => true, :on => :create # Time limit validation only on create
  
  # Avatar Upload Cropping
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
  def reprocess_image
    local_image.reprocess!
    self.image = local_image.to_file
    self.local_image = nil
  end
  def image_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(local_image.to_file(style))
  end
end