defmodule BurpWeb.MediumController do
  use BurpWeb, :controller

  alias Burp.Media

  def show(conn, %{"slug" => slug}) do
    medium = Media.get_medium_by_slug!(slug)

    conn
    |> put_resp_header("content-type", medium.media_type)
    |> put_resp_header("cache-control", "public, max-age=604800")
    |> put_resp_header(
      "expires",
      Timex.now() |> Timex.shift(days: 7) |> Timex.format!("{RFC1123}")
    )
    |> send_file(200, Media.filename(medium))
  end
end
