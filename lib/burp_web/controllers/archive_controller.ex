defmodule BurpWeb.ArchiveController do
  use BurpWeb, :controller

  alias Burp.Blog

  def years(conn, _params) do
    years = Blog.list_years(conn.assigns[:current_blog])
    render(conn, "years.html", years: years)
  end

  def months(conn, %{"year" => year} = _params) do
    months = Blog.list_months(String.to_integer(year), conn.assigns[:current_blog])
    render(conn, "months.html", months: months, year: year)
  end

  def index(conn, %{"year" => year, "mon" => month} = _params) do
    posts =
      Blog.list_posts_by_year_and_month(
        String.to_integer(year),
        from_short(month),
        conn.assigns[:current_blog]
      )

    render(
      conn,
      "index.html",
      posts: posts,
      month: Timex.beginning_of_month(year, from_short(month))
    )
  end

  @months [
    nil,
    "jan",
    "feb",
    "mar",
    "apr",
    "may",
    "jun",
    "jul",
    "aug",
    "sep",
    "oct",
    "nov",
    "dec"
  ]
  defp from_short(month_name), do: Enum.find_index(@months, &(&1 == month_name))
end
