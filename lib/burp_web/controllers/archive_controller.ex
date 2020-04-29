defmodule BurpWeb.ArchiveController do
  use BurpWeb, :controller

  alias Burp.Blog

  def years(conn, _params) do
    years = Blog.list_years(conn.assigns[:current_blog])
    render(conn, "years.html", years: years)
  end

  def months(conn, %{"year" => year_str} = _params) do
    year = year_as_int(conn, year_str)
    months = Blog.list_months(year, conn.assigns[:current_blog])
    render(conn, "months.html", months: months, year: year)
  end

  def index(conn, %{"year" => year_str, "mon" => month_str} = _params) do
    year = year_as_int(conn, year_str)
    month = from_short(conn, month_str)
    posts = Blog.list_posts_by_year_and_month(year, month, conn.assigns[:current_blog])

    render(conn, "index.html", posts: posts, month: Timex.beginning_of_month(year, month))
  end

  @months [nil, "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]
  defp from_short(conn, month_name) do
    month = Enum.find_index(@months, &(&1 == month_name))

    if is_nil(month),
      do: raise(Burp.NotFoundError, conn: conn)

    month
  end

  defp year_as_int(conn, year) do
    if Regex.match?(~r/^\d+$/, year),
      do: String.to_integer(year),
      else: raise(Burp.NotFoundError, conn: conn)
  end
end
