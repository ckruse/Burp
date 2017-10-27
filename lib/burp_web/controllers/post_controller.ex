defmodule BurpWeb.PostController do
  use BurpWeb, :controller

  alias Burp.Blog
  alias Burp.Blog.Comment

  def index(conn, _params) do
    # last_post = Blog.get_last_post(conn.assigns[:current_blog])
    all_posts = Blog.list_posts(conn.assigns[:current_blog], true, limit: [quantity: 5])

    {last_post, posts} =
      case all_posts do
        [] ->
          {nil, []}

        [head | tail] ->
          {head, tail}

        [head] ->
          {head, []}
      end

    render(conn, "index.html", last_post: last_post, posts: posts)
  end

  def show(conn, %{"year" => year, "mon" => month, "slug" => slug}) do
    full_slug = "#{year}/#{month}/#{slug}"
    post = Blog.get_post_by_slug!(full_slug, conn.assigns[:current_blog])
    render(conn, "show.html", post: post)
  end

  def index_atom(conn, _params) do
    posts = Blog.list_posts(conn.assigns[:current_blog], true, limit: [quantity: 10])
    render(conn, "index.atom", posts: posts)
  end

  def redirect_atom(conn, _params),
    do: put_status(conn, 301) |> redirect(to: post_path(conn, :index_atom))

  def redirect_rss(conn, _params),
    do: put_status(conn, 301) |> redirect(to: post_path(conn, :index_rss))
end
