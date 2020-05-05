defmodule BurpWeb.NewCommentMailer do
  use Phoenix.Swoosh, view: BurpWeb.NewCommentMailerView, layout: {BurpWeb.LayoutView, :email}
  import BurpWeb.Gettext

  def new_comment_mail(post, comment) do
    new()
    |> from({"Burp", "christian@kruse.cool"})
    |> to(post.blog.attrs["mail_notify"])
    |> subject(gettext("A new comment has been posted"))
    |> render_body(:new_comment_mail, post: post, comment: comment)
  end
end
