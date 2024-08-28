defmodule BurpWeb.Plug.EnsureAnonymous do
  @moduledoc """
  This plug can be plugged in controllers and ensures that a user is not
  signed in. It can be limited to actions by the `only` keyword. It shows
  a 403 error page when user is signed in.

  ## Examples

      # ensure that user isn't signed in for all actions
      plug EnsureAnonymous

      # ensure that user isn't signed in only for some actions
      plug EnsureAnonymous, only: [:sign_in]
  """

  import BurpWeb.Gettext

  def init(opts), do: opts

  def call(conn, opts) do
    action = Phoenix.Controller.action_name(conn)

    if action_valid?(action, opts) do
      if conn.assigns[:current_user] == nil do
        conn
      else
        conn
        |> Plug.Conn.put_status(403)
        |> Phoenix.Controller.put_flash(:error, gettext("You don't have access to this page!"))
        |> Phoenix.Controller.put_view(BurpWeb.ErrorView)
        |> Phoenix.Controller.render("403.html", conn.assigns)
        |> Plug.Conn.halt()
      end
    else
      conn
    end
  end

  defp action_valid?(action, opts) do
    cond do
      is_list(opts[:only]) && !(action in opts[:only]) ->
        false

      is_list(opts[:only]) && action in opts[:only] ->
        true

      opts[:only] == nil ->
        true

      true ->
        false
    end
  end
end
