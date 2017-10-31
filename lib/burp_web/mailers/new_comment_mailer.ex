defmodule BurpWeb.NewCommentMailer do
  use Bamboo.Phoenix, view: BurpWeb.NewCommentMailerView
  import BurpWeb.Gettext

  def new_comment_mail(post, comment) do
    new_email()
    |> from("Burp <christian@kruse.cool>")
    |> put_html_layout({BurpWeb.LayoutView, "email.html"})
    |> to(post.blog.attrs["mail_notify"])
    |> subject(gettext("A new comment has been posted"))
    |> assign(:post, post)
    |> assign(:comment, comment)
    |> render(:new_comment_mail)
  end
end
