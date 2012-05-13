class ConfirmationMailer < ActionMailer::Base
  default_url_options[:host] = ENV['MAILER_HOST']
  default from: "john@webdesignerweekend.com"
  
  def welcome_email(user)
    @user = user
    mail(:to => "#{user.username} <#{user.email}>", :subject => "Confirm Your Email")
  end
end
