// Like button
var likeButton = $(".js-post-like")
likeButton.on("click", function(e) {
  e.preventDefault() // Don't follow link
  
  $.ajax({
    url: likeButton.attr("href"),
    type: "POST",
    dataType: "json",
    success: function(data, status, xhr) {
      console.log(data);
      
      if(data.reload) // Error message
      {
        window.location.reload()
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

// Reply button
$(".comment .reply").on("click", function(e) {
  e.preventDefault()
  
  $(".new-comment #comment_blurb")
    .focus()
    .val("@"+$(".user", $(this).parent()).html()+" ")
})