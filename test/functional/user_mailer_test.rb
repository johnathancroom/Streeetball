require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  def test_welcome_email
    @user = User.new()
    @user.username = "Test"
    @user.password = "password"
    @user.email = "test@test.com"
    
    email = UserMailer.welcome_email(@user).deliver
    assert !ActionMailer::Base.deliveries.empty?
    
    assert_equal [@user.email], email.to
  end
end
