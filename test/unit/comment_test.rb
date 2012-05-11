require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "blurb should not be blank" do
    @comment = Comment.new
    @comment.valid?
    
    assert !@comment.errors.has_key?(:blurb).nil?, "Blurb was blank"
  end
  
  test "post_id should not be blank" do
    @comment = Comment.new
    @comment.valid?
    
    assert !@comment.errors.has_key?(:post_id).nil?, "Post_id was blank"
  end
  
  test "user_id should not be blank" do
    @comment = Comment.new
    @comment.valid?
    
    assert !@comment.errors.has_key?(:user_id).nil?, "User_id was blank"
  end
end
