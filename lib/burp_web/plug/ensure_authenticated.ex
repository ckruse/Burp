defmodule BurpWeb.Plug.EnsureAuthenticated do
  import BurpWeb.Gettext

  @moduledoc """
  This plug is plugged in pipelines where only signed in users have access (e.g.
  the notifications area). It ensures that the user is signed in and shows a
  403 error page if user isn't signed in.
  """

  def init(opts), do: opts

  def call(conn, _) do
    if conn.assigns[:current_user] == nil do
      conn
      |> Plug.Conn.put_status(403)
      |> Phoenix.Controller.put_flash(:error, gettext("You don't have access to this page!"))
      |> Phoenix.Controller.render(BurpWeb.ErrorView, "403.html", conn.assigns)
      |> Plug.Conn.halt()
    else
      conn
    end
  end
end
