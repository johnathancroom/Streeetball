require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # New user
  test "should not have spaces in name" do
    @user = User.new
    @user.username = "Johnathan A Croom"
    
    assert_equal "Johnathan-A-Croom", @user.username
  end
  
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
end
