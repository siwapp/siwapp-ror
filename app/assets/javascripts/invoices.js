$(document).ready(function(){
  $(window).endlessScroll({
    callback: function(){
      alert('test');
    }
  });
});
