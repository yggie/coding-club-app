$(document).ready(function () {
  var $overlay = $('.google-maps-container .google-maps-overlay');

  if ($overlay.length) {
    $overlay.on('click', function () {
      $(this).css('pointer-events', 'none').css('background-color', '');
    });

    $(document).on('click', function (event) {
      if (!$overlay.is(event.target)) {
        $overlay.css('pointer-events', '').css('background-color', 'rgba(0, 0, 0, 0.1)');
      }
    });

    $overlay.css('background-color', 'rgba(0, 0, 0, 0.1)');
  }
});
