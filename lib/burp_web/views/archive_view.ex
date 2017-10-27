defmodule BurpWeb.ArchiveView do
  use BurpWeb, :view

  def page_title(:years, %{current_blog: nil}), do: gettext("Archive — Who knows Wayne?")
  def page_title(:years, %{current_blog: blog}), do: gettext("Archive — %{name}", name: blog.name)

  def page_title(:months, %{current_blog: nil, year: year}),
    do: gettext("Archive %{year} — Who knows Wayne?", year: year)

  def page_title(:months, %{current_blog: blog, year: year}),
    do: gettext("Archive %{year} — %{name}", name: blog.name, year: year)

  def page_title(:index, %{current_blog: nil, month: month}),
    do: gettext("Archive %{year_mon} — Who knows Wayne?", year_mon: month_link_text(month))

  def page_title(:index, %{current_blog: blog, month: month}),
    do: gettext(
      "Archive %{year_mon} — %{name}",
      year_mon: month_link_text(month),
      name: blog.name
    )

  def month_link_text(month),
    do: Timex.lformat!(
      Timex.to_date(month),
      "%B %Y",
      Gettext.get_locale(BurpWeb.Gettext),
      :strftime
    )

  def month_link_month(month),
    do: Timex.format!(Timex.to_date(month), "%b", :strftime) |> String.downcase()
end
