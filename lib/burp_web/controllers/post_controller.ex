defmodule BurpWeb.PostController do
  use BurpWeb, :controller

  alias Burp.Blog

  def index(conn, _params) do
    # last_post = Blog.get_last_post(conn.assigns[:current_blog])
    all_posts = Blog.list_posts(conn.assigns[:current_blog], true, limit: [quantity: 5])

    {last_post, posts} =
      case all_posts do
        [] ->
          {nil, []}

        [head | tail] ->
          {head, tail}
      end

    render(conn, "index.html", last_post: last_post, posts: posts)
  end

  def show(conn, %{"year" => year, "mon" => month, "slug" => slug}) do
    full_slug = "#{year}/#{month}/#{slug}"
    post = Blog.get_post_by_slug!(full_slug, conn.assigns[:current_blog])

    conn
    |> put_comment_token()
    |> render("show.html", post: post)
  end

  def index_rss(conn, _params) do
    posts = Blog.list_posts(conn.assigns[:current_blog], true, limit: [quantity: 10])

    conn
    |> put_resp_header("content-type", "application/rss+xml; charset=utf-8")
    |> render("index.rss", posts: posts)
  end

  def index_atom(conn, _params) do
    posts = Blog.list_posts(conn.assigns[:current_blog], true, limit: [quantity: 10])

    conn
    |> put_resp_header("content-type", "application/atom+xml; charset=utf-8")
    |> render("index.atom", posts: posts)
  end

  def redirect_atom(conn, _params), do: put_status(conn, 301) |> redirect(to: Routes.post_path(conn, :index_atom))

  def redirect_rss(conn, _params), do: put_status(conn, 301) |> redirect(to: Routes.post_path(conn, :index_rss))

  defp put_comment_token(conn) do
    with cookie when not is_nil(cookie) <- conn.cookies["commenting"],
         {:ok, _} <- Phoenix.Token.verify(conn, "commenting", cookie, max_age: 3600) do
      conn
    else
      _ ->
        token = Phoenix.Token.sign(conn, "commenting", Timex.to_unix(Timex.now()))
        put_resp_cookie(conn, "commenting", token)
    end
  end
end
