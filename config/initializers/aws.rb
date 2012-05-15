S3 = AWS::S3::Base.establish_connection!(
  :access_key_id => ENV['AWS_S3_ACCESS_KEY_ID'],
  :secret_access_key => ENV['AWS_S3_SECRET_ACCESS_KEY']
)