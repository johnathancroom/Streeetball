# Interpolation Additions for Paperclip :path
# Derived from: http://stackoverflow.com/questions/7809107/rails-3-paperclip-path-for-storing-images
Paperclip.interpolates :username { |attachment, style| attachment.instance.username }
Paperclip.interpolates :post_username { |attachment, style| attachment.instance.user.username }