defmodule BurpWeb.Admin.ConfigView do
  use BurpWeb, :view

  def has_subnav?(_, _), do: true

  def subnav(_, conn, assigns),
    do: render(BurpWeb.AdminView, "subnav.html", Map.put(assigns, :conn, conn))
end
