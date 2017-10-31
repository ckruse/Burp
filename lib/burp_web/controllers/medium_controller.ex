defmodule BurpWeb.MediumController do
  use BurpWeb, :controller

  alias Burp.Media

  def show(conn, %{"slug" => slug}) do
    medium = Media.get_medium_by_slug!(slug)
    send_file(conn, 200, Media.filename(medium))
  end
end
