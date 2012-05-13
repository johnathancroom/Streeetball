module ApplicationHelper
  def s3_image_tag(source, options = {})
    # derived from image_tag
    # http://api.rubyonrails.org/classes/ActionView/Helpers/AssetTagHelper.html#method-i-image_tag
    
    options.symbolize_keys!
    
    src = options[:src] = "https://streeetball.s3.amazonaws.com/#{source}"
  
    if size = options.delete(:size)
      options[:width], options[:height] = size.split("x") if size =~ %r{^\d+x\d+$}
    end
    
    tag("img", options)
  end
end
