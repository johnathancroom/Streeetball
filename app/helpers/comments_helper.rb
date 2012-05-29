module CommentsHelper
  # Add links to profiles on mentions in comments
  def parse_mentions(blurb)
    raw blurb.gsub(/(?<user>@([A-Z]|[a-z])+)/) { # Search for @name format
      @username = $1
      if @user = User.where('lower(username) = lower(?)', @username.gsub(/@/, '')).first # Check if username exists
        link_to "@#{@user.username}", user_path(@user) # Return link to username
      else
        @username
      end
    }
  end
end
