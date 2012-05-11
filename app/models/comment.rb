class Comment < ActiveRecord::Base
  attr_accessible :blurb, :post_id, :user_id
  
  belongs_to :user
  belongs_to :post
  
  validates_presence_of :blurb, :user_id, :post_id
end
