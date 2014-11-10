(function ($, document) {
  'use strict';

  $(document).on('ready', function () {
    var $forms = $('form.has-preview');

    $.each($forms, function (index, item) {
      var $form = $(item),
          $previewButton = $form.find('.generate-preview-button'),
          $preview = $form.find('iframe.newsletter-preview'),
          url = $form.data('url');

      if ($previewButton.length && $preview.length) {
        $previewButton.on('click', function () {
          $.ajax({
            method: 'POST',
            data: $form.serialize(),
            url: url,
            dataType: 'html',
            success: function (data) {
              $preview.contents().find('html').html(data);
            },
          });
        }).click();
      }
    });
  });
}).call(this, jQuery, document);
