defmodule BurpWeb.Plug.SetLocale do
  @moduledoc """
  This plug is plugged in the browser pipeline and sets the locale
  based on the current blog
  """
  def init(opts), do: opts

  def call(conn, _opts) do
    current_blog = conn.assigns[:current_blog]

    if current_blog != nil do
      Gettext.put_locale(BurpWeb.Gettext, current_blog.lang)
    end

    conn
  end
end
