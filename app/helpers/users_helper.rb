module UsersHelper
  def profile_image_tag(source, options = {})
    if !source.image_url.nil?
      s3_image_tag source.image_url, options
    else
      # Default profile image
      s3_image_tag 'default_profile_image.jpeg', options
    end
  end
  
  def link_to_dribbble(user, options= {})
    if user.dribbble_username
      link_to user.dribbble_username, "http://dribbble.com/#{user.dribbble_username}", options
    end
  end
  
  def link_to_twitter(user, options= {})
    if user.twitter_username
      link_to user.twitter_username, "http://twitter.com/#{user.twitter_username}", options
    end
  end
end
