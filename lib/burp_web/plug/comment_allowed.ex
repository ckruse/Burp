defmodule BurpWeb.Plug.CommentAllowed do
  import BurpWeb.Gettext

  alias Burp.Blog

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.assigns[:current_blog].attrs["comments"] != "disabled" do
      %{"year" => year, "mon" => month, "slug" => slug} = conn.params
      full_slug = "#{year}/#{month}/#{slug}"
      post = Blog.get_post_by_slug!(full_slug, conn.assigns[:current_blog])

      if post.attrs["comments"] != "disabled",
        do: conn,
        else: comments_disallowed(conn)
    else
      comments_disallowed(conn)
    end
  end

  defp comments_disallowed(conn) do
    conn
    |> Plug.Conn.put_status(403)
    |> Phoenix.Controller.put_flash(:error, gettext("Comments aren't allowed!"))
    |> Phoenix.Controller.render(BurpWeb.ErrorView, "403.html", conn.assigns)
    |> Plug.Conn.halt()
  end
end
