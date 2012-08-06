require 'net/http'

class HookMailer < ActionMailer::Base
  default_url_options[:host] = ENV['MAILER_HOST']
  
  def like_email(user, post)
    @user = user
    @owner = post.user
    @post = post
    @subject = "#{@user.username} likes #{@post.name}"
    @message_plain = render 'hook_mailer/like_email.text'
    @message_html = render 'hook_mailer/like_email.html'
    
    hook_email
  end
  
  def comment_email(user, post)
    @user = user
    @owner = post.user
    @post = post
    @subject = "#{@user.username} commented on #{@post.name}"
    @message_plain = render 'hook_mailer/comment_email.text'
    @message_html = render 'hook_mailer/comment_email.html'
    
    hook_email
  end
  
  # Handle Emails on PHP MediaTemple Server
  def hook_email
    Net::HTTP.post_form(URI.parse('http://builtbyalpha.com/index.php'), { 
      'to'=> "#{@owner.username} <#{@owner.email}>",
      'subject' => @subject,
      'message_plain' => @message_plain,
      'message_html' => @message_html
    })
  end
end
