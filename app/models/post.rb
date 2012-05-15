class Post < ActiveRecord::Base
  attr_accessible :name, :user_id, :image, :description
  
  has_attached_file :image,
    :storage => :s3, 
    :s3_credentials => {
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET']
    },
    :bucket => ENV['S3_BUCKET'],
    :path => ':post_username/:id/:basename_:style.:extension',
    :styles => {
      :original => ['400x300#', :jpg],
      :small => ['192x144#', :jpg]
    }
  
  has_many :comments
  has_many :likes
  belongs_to :user
  
  validates_presence_of :name, :user_id
  validates_attachment_presence :image
end
