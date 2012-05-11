class Post < ActiveRecord::Base
  attr_accessible :image_url, :name, :user_id
  
  validates_presence_of :name, :image_url, :user_id
end
