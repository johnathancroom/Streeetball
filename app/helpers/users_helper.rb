module UsersHelper
  def profile_image_tag(source, options = {})
    if !source.image_url.nil?
      s3_image_tag source.image_url, options
    else
      # Default profile image
      s3_image_tag 'default_profile_image.jpeg', options
    end
  end
  
  def link_to_dribbble(user)
    if user.dribbble_username
      link_to "@#{user.dribbble_username}", "http://dribbble.com/#{user.dribbble_username}"
    end
  end
end
