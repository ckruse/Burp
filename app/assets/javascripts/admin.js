/* -*- coding: utf-8 -*- */

//= require bootstrap
//= require jquery.elastic.source.js
//= require urlify.js

$(document).on('ready', function() {
  $("#comments-select-all").on('click', function(ev) {
    ev.preventDefault();
    $(".comment.row input[type=checkbox]").click();
  });
});


// eof
