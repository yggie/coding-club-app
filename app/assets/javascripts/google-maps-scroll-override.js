$(document).ready(function () {
  var $overlay = $('.google-maps-container .google-maps-overlay');

  if ($overlay.length) {
    $overlay.on('click', function () {
      $(this).css('pointer-events', 'none');
    });

    $(document).on('click', function (event) {
      if (!$overlay.is(event.target)) {
        $overlay.css('pointer-events', '');
      }
    });
  }
});
