defmodule BurpWeb.PostView do
  use BurpWeb, :view

  import BurpWeb.AtomBuilder

  def posting_url(conn, post) do
    post_url(conn, :index) <> post.slug
  end

  def as_html(%{posting_format: "html"}, html), do: {:safe, html}
  def as_html(_, markdown), do: {:safe, Cmark.to_html(markdown)}

  def comment_changeset do
    Burp.Blog.change_comment(%Burp.Blog.Comment{})
  end

  def render("index.atom", %{conn: conn, posts: posts, current_blog: current_blog}) do
    {
      :feed,
      %{xmlns: "http://www.w3.org/2005/Atom"},
      [
        title(current_blog),
        subtitle(current_blog),
        self_link(conn, current_blog),
        updated(List.first(posts)),
        author(current_blog),
        {:generator, %{url: "https://github.com/ckruse/burp"}, "Burp"},
        entries(conn, posts, current_blog)
      ]
    }
    |> XmlBuilder.generate()
  end
end
