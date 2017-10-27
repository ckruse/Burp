defmodule BurpWeb.CommentView do
  use BurpWeb, :view

  def new_comment_url(conn, post) do
    BurpWeb.PostView.posting_url(conn, post)
  end

  def comment_html(comment) do
    {:safe, Cmark.to_html(comment.content, [:safe, :smart])}
  end
end
