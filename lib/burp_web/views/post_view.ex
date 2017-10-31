defmodule BurpWeb.PostView do
  use BurpWeb, :view

  import BurpWeb.XmlBuilder

  def comment_changeset do
    Burp.Blog.change_comment(%Burp.Blog.Comment{})
  end

  def render("index.atom", %{conn: conn, posts: posts, current_blog: current_blog}) do
    {
      :feed,
      %{xmlns: "http://www.w3.org/2005/Atom"},
      [
        {:id, nil, post_url(conn, :index_atom)},
        title(current_blog),
        description(:subtitle, current_blog),
        self_link(conn, current_blog),
        updated(List.first(posts)),
        author(current_blog),
        {:generator, %{uri: "https://github.com/ckruse/burp"}, "Burp"},
        entries(conn, posts, current_blog)
      ]
    }
    |> XmlBuilder.generate()
  end

  def render("index.rss", %{conn: conn, posts: posts, current_blog: current_blog}) do
    {
      :rss,
      %{"version" => "2.0", "xmlns:atom" => "http://www.w3.org/2005/Atom"},
      [
        {
          :channel,
          nil,
          [
            title(current_blog),
            description(:description, current_blog),
            {:link, nil, post_url(conn, :index_rss)},
            {
              "atom:link",
              %{href: post_url(conn, :index_rss), rel: "self", type: "application/rss+xml"},
              nil
            },
            items(conn, posts, current_blog)
          ]
        }
      ]
    }
    |> XmlBuilder.generate()
  end
end
