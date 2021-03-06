import "../css/app.css";
import "phoenix_html";

import Urlify from "urlify/dist/urlify-dev";
import PreviewRenderer from "./preview-renderer";
import CommentPreviewRenderer from "./comment-preview-renderer";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

document.addEventListener("DOMContentLoaded", function () {
  let subj = document.getElementById("post_subject");
  let urlify = Urlify.create({
    spaces: "-",
    toLower: true,
    nonPrintable: "-",
    trim: true,
    addEToUmlauts: true,
  });

  if (subj) {
    subj.addEventListener("change", function () {
      if (this.value != "") {
        document.getElementById("post_slug").value = urlify(subj.value);
      }
    });
  }

  let container = document.getElementById("post-preview");
  if (container) {
    let excerpt = document.getElementById("post_excerpt");
    let content = document.getElementById("post_content");
    new PreviewRenderer(container, subj, excerpt, content);
  }

  let commentContainer = document.getElementById("comment-preview");
  if (commentContainer) {
    let author = document.getElementById("comment_author");
    let url = document.getElementById("comment_url");
    let email = document.getElementById("comment_email");
    let content = document.getElementById("comment_content");
    new CommentPreviewRenderer(commentContainer, author, url, email, content);
  }
});

/* eof */
