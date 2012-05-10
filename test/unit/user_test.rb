require 'test_helper'
require 'bcrypt'

class UserTest < ActiveSupport::TestCase
  # New user  
  test "should not save without username" do
    @user = User.new
    @user.valid?
    
    assert @user.errors.has_key?(:username), "Saved User without username"
  end
  
  test "should not save without password" do
    @user = User.new
    @user.valid?
    
    assert @user.errors.has_key?(:password_hash), "Saved User without password"
  end
  
  test "should encrypt password" do
    @user = User.new
    @user.password = "pass"
    
    test = BCrypt::Password.new(@user.password_hash)
    
    assert_not_equal "pass", test
  end
end
