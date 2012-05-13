var likeButton = $(".js-post-like")
likeButton.on("click", function(e) {
  e.preventDefault() // Don't follow link
  
  $.ajax({
    url: likeButton.attr("href"),
    type: "POST",
    dataType: "json",
    success: function(data, status, xhr) {
      // Not logged in
      if(data.redirect)
      {
        window.location = data.redirect // redirect to login page
      }
      else
      {
        if(data.like)
        {
          likeButton.addClass("liked")
        }
        else
        {
          likeButton.removeClass("liked")
        }
      
        likeButton.html(data.count)
      }
    },
    error: function(xhr, status, error) {
      throwError(xhr);
    }
  })
})