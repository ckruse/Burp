defmodule BurpWeb.AdminView do
  use BurpWeb, :view

  def active_class(conn, mod) do
    if Phoenix.Controller.controller_module(conn) == mod do
      "active"
    else
      ""
    end
  end
end
