defmodule BurpWeb.LayoutView do
  use BurpWeb, :view

  def page_author(_conn, %{post: post}) when not is_nil(post), do: post.author.name
  def page_author(_conn, %{current_blog: blog}) when not is_nil(blog), do: blog.author.name
  def page_author(_conn, _assigns), do: "Christian Kruse"

  def page_description(_conn, %{post: %{excerpt: excerpt}})
      when not is_nil(excerpt) and excerpt != "",
      do: excerpt

  def page_description(_conn, %{current_blog: blog}) when not is_nil(blog), do: blog.description
  def page_description(_conn, _assigns), do: gettext("Who knows Wayne?")

  def page_keywords(_conn, %{post: %{tags: tags}}) when not is_nil(tags) and tags != [] do
    tags
    |> Enum.map(& &1.tag_name)
    |> Enum.join(", ")
  end

  def page_keywords(_conn, %{current_blog: %{keywords: keywords}})
      when not is_nil(keywords) and keywords != "",
      do: keywords

  def page_keywords(_conn, _assigns), do: "wayne, ck, christian, kruse"

  def page_title(conn, assigns) do
    try do
      apply(view_module(conn), :page_title, [action_name(conn), assigns])
    rescue
      UndefinedFunctionError -> default_page_title(conn, assigns)
      FunctionClauseError -> default_page_title(conn, assigns)
    end
  end

  def default_page_title(_conn, %{post: %{title: title}}) when not is_nil(title) and title != "",
    do: title

  def default_page_title(_conn, %{current_blog: blog}) when not is_nil(blog), do: blog.name
  def default_page_title(_conn, _assigns), do: gettext("Who knows Wayne?")

  def subnav(conn, assigns) do
    # try do
    apply(view_module(conn), :subnav, [action_name(conn), conn, assigns])
    # rescue
    # UndefinedFunctionError -> false
    # FunctionClauseError -> false
    # end
  end

  def has_subnav?(conn, assigns) do
    try do
      apply(view_module(conn), :has_subnav?, [action_name(conn), assigns])
    rescue
      _ -> false
    end
  end
end
