# Load the rails application
require File.expand_path('../application', __FILE__)

require File.join(File.dirname(__FILE__), 'boot')
# Load heroku vars from local file
# http://tammersaleh.com/posts/managing-heroku-environment-variables-for-local-development
env_vars = File.join(Rails.root, 'config', 'env_vars.rb')
load(env_vars) if File.exists?(env_vars)

# Initialize the rails application
Streeetball::Application.initialize!

# Mailer Config
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
  :address => 'smtp.gmail.com',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true,
  :user_name => ENV['GMAIL_USERNAME'],
  :password => ENV['GMAIL_PASSWORD']
}