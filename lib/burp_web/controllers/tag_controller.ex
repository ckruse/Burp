defmodule BurpWeb.TagController do
  use BurpWeb, :controller

  alias Burp.Blog

  def index(conn, _params) do
    tags = Blog.list_tags(conn.assigns[:current_blog])

    {_, min_count} = Enum.min_by(tags, fn {_, cnt} -> cnt end)
    {_, max_count} = Enum.max_by(tags, fn {_, cnt} -> cnt end)

    render(conn, "index.html", tags: tags, min_count: min_count, max_count: max_count)
  end

  def show(conn, %{"tag" => tag} = _params) do
    posts = Blog.list_posts_by_tag(tag, conn.assigns[:current_blog])
    render(conn, "show.html", tag: tag, posts: posts)
  end
end
