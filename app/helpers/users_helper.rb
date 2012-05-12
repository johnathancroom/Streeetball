module UsersHelper
  def profile_image_tag(source, options = {})
    if !source.image_url.nil?
      s3_image_tag source.image_url, options
    else
      # Default profile image
      s3_image_tag 'default_profile_image.jpeg', options
    end
  end
  
  def link_to_dribbble(username)
    link_to "@#{username}", "http://dribbble.com/#{username}"
  end
end
