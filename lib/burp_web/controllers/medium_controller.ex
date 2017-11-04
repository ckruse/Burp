defmodule BurpWeb.MediumController do
  use BurpWeb, :controller

  alias Burp.Media

  def show(conn, %{"slug" => slug}) do
    medium = Media.get_medium_by_slug!(slug)

    conn
    |> put_resp_header("Content-Type", medium.media_type)
    |> send_file(200, Media.filename(medium))
  end
end
