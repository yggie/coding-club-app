$(document).ready(function () {
  var $text = $('.matrix-text');

  if ($text.length) {
    var generateRowTexts = function (options) {
      options = options || {};

      var columns = options.columns || 40,
          minHeight = options.minHeight || 2,
          padding = options.padding || 1,
          spacing = options.spacing || 4,
          rows = options.rows || 8;

      var range = rows - minHeight,
          columnTexts = [],
          i = 0, j = 0;

      for (i = 0; i < columns; i++) {
        var height = Math.ceil(Math.random() * range) + minHeight,
            textArray = [];
        for (j = 0; j < height; j++) {
          textArray.push(String(Math.round(Math.random())));
        }

        columnTexts.push(textArray);
      }

      var rowTexts = [],
          emptyColumn = Array(spacing + 2).join(' '),
          columnPaddingText = Array(spacing + 1).join(' ');

      for (i = 0; i < rows; i++) {
        var text = Array(padding + 1).join(emptyColumn);

        for (j = 0; j < columns; j++) {
          var columnText = columnTexts[j];
          if (columnText.length) {
            text += columnPaddingText + columnText.shift();
          } else {
            text += emptyColumn;
          }
        }

        rowTexts.unshift(text);
      }

      return rowTexts;
    };


    var shuffleRow = function (row) {
      return row.replace(/[01]/g, function (match) {
        return (match === '0') ? '1' : '0';
      });
    };


    var oldRowTexts = [];


    var performShuffleRows = function (start, end) {
      end = end + 1;
      for (var i = start; i < end; i++) {
        if (i > -1) {
          oldRowTexts[i] = shuffleRow(oldRowTexts[i]);
        }
      }

      $text.text(oldRowTexts.join('\n'));
    };


    var performAsyncThen = function (options) {
      var operation = options.operation,
          repeats = options.repeats,
          wait = options.wait,
          end = options.end;

      var repeater = function () {
        if (repeats--) {
          operation.call(null);

          setTimeout(repeater, wait);
        } else {
          end.call(null);
        }
      };

      setTimeout(repeater, wait);
    };


    var generateNewText = function () {
      oldRowTexts = generateRowTexts();
      $text.text(oldRowTexts.join('\n'));
    };


    var refreshText = function () {
      var height = oldRowTexts.length;

      performAsyncThen({
        repeats: 3,
        wait: 80,
        operation: function () {
          performShuffleRows(0, height - 1);
        },
        end: function () {
          generateNewText();
          setTimeout(refreshText, 7000);
        }
      });
    };

    generateNewText();
    setTimeout(refreshText, 7000);
  }
});
