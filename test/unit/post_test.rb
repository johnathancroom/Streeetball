require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test "should not save without name" do
    @post = Post.new
    @post.valid?
    
    assert @post.errors.has_key?(:name), "Saved without name"
  end
  
  test "should not save without user" do
    @post = Post.new
    @post.valid?
    
    assert @post.errors.has_key?(:user_id), "Saved without user_id"
  end
end
