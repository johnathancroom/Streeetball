class Post < ActiveRecord::Base
  attr_accessible :image_url, :name, :user_id, :image
  attr_accessor :image
  
  has_many :comments
  belongs_to :user
  
  validates_presence_of :name, :image, :user_id
end
