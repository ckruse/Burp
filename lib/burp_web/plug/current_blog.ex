defmodule BurpWeb.Plug.CurrentBlog do
  @moduledoc """
  This plug is plugged in the browser pipeline and loads and assigns the
  current blog
  """
  def init(opts), do: opts

  def call(conn, _opts) do
    current_blog = Burp.Meta.get_blog_by_host(conn.host)
    Plug.Conn.assign(conn, :current_blog, current_blog)
  end
end
