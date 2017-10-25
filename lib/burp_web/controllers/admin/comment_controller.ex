defmodule BurpWeb.Admin.CommentController do
  use BurpWeb, :controller

  alias Burp.Blog
  alias Burp.Blog.Comment

  def index(conn, params) do
    count = Blog.count_comments(conn.assigns[:current_blog], false)
    paging = paginate(count, page: params["p"])
    comments = Blog.list_comments(conn.assigns[:current_blog], false, limit: paging.params)
    render(conn, "index.html", comments: comments, paging: paging)
  end

  def edit(conn, %{"id" => id}) do
    comment = Blog.get_comment!(id)
    changeset = Blog.change_comment(comment)
    render(conn, "edit.html", comment: comment, changeset: changeset)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Blog.get_comment!(id)

    case Blog.update_comment(comment, comment_params) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, gettext("Comment updated successfully."))
        |> redirect(to: admin_comment_path(conn, :edit, comment))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", comment: comment, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Blog.get_comment!(id)
    {:ok, _comment} = Blog.delete_comment(comment)

    conn
    |> put_flash(:info, gettext("Comment deleted successfully."))
    |> redirect(to: admin_comment_path(conn, :index))
  end
end
