class UserMailer < ActionMailer::Base
  default_url_options[:host] = ENV['MAILER_HOST']
  default :from => 'Streeetball <somebody@streeetball.com>'
  
  def welcome_email(user)
    @user = user
    mail :to => "#{user.username} <#{user.email}>", :subject => 'Confirm Your Email'
  end
  
  def password_reset(user)
    @user = user
    mail :to => "#{user.username} <#{user.email}>", :subject => 'Password Reset'
  end
end
