defmodule BurpWeb.Admin.PostController do
  use BurpWeb, :controller

  alias Burp.Blog
  alias Burp.Blog.Post

  def index(conn, params) do
    count = Blog.count_posts(conn.assigns[:current_blog], false)
    paging = paginate(count, page: params["p"])
    posts = Blog.list_posts(conn.assigns[:current_blog], false, limit: paging.params)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Blog.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    case Blog.create_post(post_params, conn.assigns[:current_blog], conn.assigns[:current_user]) do
      {:ok, post} ->
        conn
        |> put_flash(:info, gettext("Post created successfully."))
        |> redirect(to: admin_post_path(conn, :edit, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    post = Blog.get_post!(id, conn.assigns[:current_blog], false)
    changeset = Blog.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Blog.get_post!(id, conn.assigns[:current_blog], false)

    case Blog.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, gettext("Post updated successfully."))
        |> redirect(to: admin_post_path(conn, :edit, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Blog.get_post!(id, conn.assigns[:current_blog], false)
    {:ok, _post} = Blog.delete_post(post)

    conn
    |> put_flash(:info, gettext("Post deleted successfully."))
    |> redirect(to: admin_post_path(conn, :index))
  end
end
