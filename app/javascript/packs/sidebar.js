$(document).on('turbolinks:load', function() {
  $('.container-fluid').on('click', '.sidebarCollapse', function () {
    $('.sidebar').toggleClass('active');
  });
});
