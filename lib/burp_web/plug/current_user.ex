defmodule BurpWeb.Plug.CurrentUser do
  @moduledoc """
  This plug is plugged in the browser pipeline and loads and assigns the
  current user
  """
  def init(opts), do: opts

  def call(conn, _opts) do
    uid = Plug.Conn.get_session(conn, :author_id)

    current_user =
      if uid != nil,
        do: Burp.Meta.get_author!(uid),
        else: nil

    Plug.Conn.assign(conn, :current_user, current_user)
  end
end
