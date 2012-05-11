class Comment < ActiveRecord::Base
  attr_accessible :blurb, :post_id, :user_id
end
