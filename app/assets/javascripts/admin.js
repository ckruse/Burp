/* -*- coding: utf-8 -*- */

//= require bootstrap
//= require jquery.elastic.source.js
//= require urlify.js

dashboard = {
  deleteComment: function(obj) {
  }
};

$(document).on('ready', function() {
  $(".well.comments").on('click', function() {
    var action = $(this).attr('data-js');

    switch(action) {
      case 'delete-comment':
      dashboard.deleteComment(this);
      break;

      case 'hide-comment':
      dashboard.hideComment(this);
      break;

      case 'show-comment':
      dashboard.showComment(this);
      break;
    }

  });
});

// eof
