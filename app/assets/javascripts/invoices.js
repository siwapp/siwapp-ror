var page = 2;
var there_is_still_pages = true;
$(document).ready(function(){
  getNextPage = function(){
    if (($(window).scrollTop() >= $(document).height() - $(window).height() - 100) && there_is_still_pages) {
      $.get('/invoices_ajax/' + page, function(data){
        console.log('hey ' + page);
        if (data) {
          $('table.table tr:last').after(data);
          page += 1;
        } else {
          there_is_still_pages = false;
        }
      });
    }
  };
  $(window).scroll(function(){
    $.doTimeout('scroll', 200, getNextPage);
  });
});
