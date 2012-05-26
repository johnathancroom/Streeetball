module UsersHelper
  def link_to_dribbble(user, options= {})
    if user.dribbble_username && !user.dribbble_username.empty?
      link_to ' Draft me', "http://dribbble.com/#{user.dribbble_username}", options
    end
  end
  
  def link_to_twitter(user, options= {})
    if user.twitter_username && !user.twitter_username.empty?
      link_to user.twitter_username, "http://twitter.com/#{user.twitter_username}", options
    end
  end
end

