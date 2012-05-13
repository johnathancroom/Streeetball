var likeButton = $(".js-post-like")
likeButton.on("click", function(e) {
  e.preventDefault() // Don't follow link
  
  $.ajax({
    url: likeButton.attr("href"),
    type: "POST",
    dataType: "json",
    success: function(data, status, xhr) {
      if($.isEmptyObject(data)) // Returns empty if this is your post
      {
        return
      }
      
      if(data.redirect) // Not logged in
      {
        window.location = data.redirect // redirect to login page
      }
      else // Logged in
      {
        if(data.like) // Liked
        {
          likeButton.addClass("liked")
        }
        else // Unliked
        {
          likeButton.removeClass("liked")
        }
      
        likeButton.html(data.count) // Update like-count
      }
    },
    error: function(xhr, status, error) {
      throwError(xhr);
    }
  })
})