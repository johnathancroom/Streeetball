class User < ActiveRecord::Base
  attr_accessible :password, :username
  
  validates_presence_of :username, :password
  
  # Remove dashes from username
  def username
    @username
  end
  def username=(value)
    @username = value.gsub(" ", "-")
  end
end
