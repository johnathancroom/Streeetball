class Post < ActiveRecord::Base
  attr_accessible :image_url, :name, :user_id
end
