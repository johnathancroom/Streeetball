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
    
    assert @user.errors.has_key?(:password), "Saved User without password"
  end
  
  test "should encrypt password" do
    @user = User.find(:first)
    @user.password = "pass"
    @user.save
    
    assert_not_equal "MyString", @user.password_hash, "Password hash not created"
  end
end
