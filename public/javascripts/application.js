$(function() {
  $('#loading').ajaxStart(function() {
    $(this).fadeIn('slow');
  });
  
  $('#loading').ajaxStop(function() {
    $(this).fadeOut('slow');
  });
  
  $(document).bind('questions:reload', function() {
    $.ajax({
      type:'GET',
      url:'/api/v1/questions',
      dataType:'json',
      success:function(data) {
        var build = $('<ul/>')
        $.each(data, function() {
          build.append("<li data-id='" + this.id + "'><img class='avatar' src='http://img.tweetimag.es/i/" + this.screen_name + "_n'/> " + this.text + "</li>");
        });
        
        $('#question_list').html(build.html());
      },
      error:function() {
        alert("Unable to refresh the question list.");
      }
    });
  });
  
  $(document).trigger('questions:reload');
  setInterval(function() {
    $(document).trigger('questions:reload');
  }, 30000);
  
  $('form#ask').submit(function() {
    $.ajax({
      type:'POST',
      url:'/api/v1/questions',
      data:$('form#ask').serialize(),
      dataType:'json',
      success:function(data) {
        $(document).trigger('questions:reload');
        $('form#ask')[0].reset();
      },
      error:function() {
        alert("There was a problem asking your question.");
      }
    });
    return false;
  });
});