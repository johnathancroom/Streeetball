// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
/*
= require jquery
= require jquery.color
= require jquery.Jcrop.min
= require posts
= require ga
*/

/* Error function, yo */
function throwError(error) {
  alert("Error\nCheck console")
  console.log(error)
}

$(document).ready(function() {
  /* Put the footer down bottom if the content isn't long enough */
  function adjustFooter() {
    var windowHeight = $(window).height()
    var contentHeight = $("body").height()
    
    var extraHeight = 0;
    if($("footer").css("position") == "fixed")
    {
      extraHeight = $("footer").height() + 35
    }
    else
    {
      extraHeight = 0
    }
    
    if(contentHeight < windowHeight-extraHeight)
    {
      $("footer").css({
        position: "fixed"
      })
    }
    else
    {
      $("footer").css({
        position: "static"
      })
    }
  }
  setInterval(function() {
    adjustFooter()
  }, 100)
  $(window).resize(function() {
    adjustFooter()
  })
})