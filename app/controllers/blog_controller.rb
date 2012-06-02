class BlogController < ApplicationController
  def index
    @posts = Dir.new('app/views/blog/posts').entries # Get blog files
    @posts.delete_if { |x| x == '.' || x == '..' } # Remove current directory and upper directory
    
    @posts.sort.reverse.each_with_index do |post, index|
      @posts[index] = get_post_info(post)
    end
  end
  
  def show
    post_name = Dir.glob("app/views/blog/posts/*-#{params[:id]}.html", File::FNM_CASEFOLD).first # Find file ignoring case
    if !post_name.nil?
      @post = get_post_info(File.basename(post_name))
    else
      render_404
    end
  end
  
  def get_post_info(fullname)
    regex_date = /(?<date>\d{2}-\d{2}-\d{4}-)/
    
    post = fullname.gsub(regex_date, '') # Remove date
    
    date = fullname.gsub(/-#{post}/, '') # Remove everything except date
    date = Date.strptime(date, "%m-%d-%Y") # Convert string to date
    
    post = post.gsub(/\.([A-Z]|[a-z]+)/, '') # Remove extension
    
    content = File.new("app/views/blog/posts/#{fullname}").read # Read file contents
  
    # Return hash with values
    {
      :path => post.downcase, # Lowercase the link
      :date => date,
      :content => content,
      :title => post.gsub(/-/, ' ') # Replace dashes with spaces
    }
  end
end