defmodule BurpWeb.Admin.CommentView do
  use BurpWeb, :view

  def has_subnav?(_, _), do: true
  def subnav(_, conn, assigns), do: render("subnav.html", Map.put(assigns, :conn, conn))

  def comment_url(conn, comment),
    do: BurpWeb.PostView.posting_url(conn, comment.post) <> "#comment-#{comment.id}"

  def comment_url(conn, comment, post),
    do: BurpWeb.PostView.posting_url(conn, post) <> "#comment-#{comment.id}"
end
