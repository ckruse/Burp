defmodule BurpWeb.CommentController do
  use BurpWeb, :controller

  alias Burp.Blog

  plug(BurpWeb.Plug.CommentAllowed)

  def create(conn, %{"comment" => comment_params, "year" => year, "mon" => month, "slug" => slug}) do
    full_slug = "#{year}/#{month}/#{slug}"
    post = Blog.get_post_by_slug!(full_slug, conn.assigns[:current_blog])

    case Blog.create_comment(comment_params, post) do
      {:ok, comment} ->
        BurpWeb.NewCommentMailer.new_comment_mail(post, comment)
        |> Burp.Mailer.deliver_later()

        conn
        |> put_notification(comment)
        |> redirect(to: WebHelpers.posting_path(conn, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, post: post)
    end
  end

  defp put_notification(conn, %{visible: true}), do: put_flash(conn, :info, gettext("Comment created successfully."))

  defp put_notification(conn, _),
    do: put_flash(conn, :info, gettext("Comment created successfully. Please await moderation."))
end
