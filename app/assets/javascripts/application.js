//= require jquery
//= require jquery_ujs
//= require activestorage
//= require popper
//= require bootstrap
//= require jcrop
//= require avatar
//= require select_all.js
//= require jquery-ui/core
//= require jquery-ui/widget
//= require jquery-ui/position
//= require jquery-ui/widgets/autocomplete
//= require jquery-ui/widgets/menu
//= require url
//= require spin
//= require jquery.spin
//= require ajax_period
//= require word

$(document).ready(function() {
  $('#form-modal-save-btn').click(function() {
    $('#form-modal-body').find('form').submit();
  });

  toastr.options = {
    "closeButton": false,
    "debug": false,
    "newestOnTop": false,
    "progressBar": false,
    "positionClass": "toast-top-center",
    "preventDuplicates": false,
    "onclick": null,
    "showDuration": "100",
    "hideDuration": "1000",
    "timeOut": "1000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  }
})
