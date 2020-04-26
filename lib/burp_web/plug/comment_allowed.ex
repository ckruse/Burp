defmodule BurpWeb.Plug.CommentAllowed do
  import BurpWeb.Gettext

  alias Burp.Blog

  def init(opts), do: opts

  def call(conn, _opts) do
    with true <- comment_allowed?(conn.assigns[:current_blog].attrs["comments"]),
         post <- get_post(conn.params, conn.assigns[:current_blog]),
         true <- comment_allowed?(post.attrs["comments"]),
         true <- comment_allowed_by_token?(conn.cookies["commenting"], conn) do
      conn
    else
      _ -> comments_disallowed(conn)
    end
  end

  defp comments_disallowed(conn) do
    conn
    |> Plug.Conn.put_status(403)
    |> Phoenix.Controller.put_flash(:error, gettext("Comments aren't allowed!"))
    |> Phoenix.Controller.put_view(BurpWeb.ErrorView)
    |> Phoenix.Controller.render("403.html", conn.assigns)
    |> Plug.Conn.halt()
  end

  defp comment_allowed?("disabled"), do: false
  defp comment_allowed?(_), do: true

  defp get_post(%{"year" => year, "mon" => month, "slug" => slug}, blog) do
    full_slug = "#{year}/#{month}/#{slug}"
    Blog.get_post_by_slug!(full_slug, blog)
  end

  defp get_post(_, _), do: nil

  defp comment_allowed_by_token?(nil, _), do: false

  defp comment_allowed_by_token?(token, conn) do
    case Phoenix.Token.verify(conn, "commenting", token, max_age: 3600) do
      {:ok, age} ->
        ts = Timex.from_unix(age)
        Timex.diff(Timex.now(), ts, :seconds) > 15

      _ ->
        false
    end
  end
end
