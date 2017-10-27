defmodule BurpWeb.AtomBuilder do
  import BurpWeb.Gettext
  import BurpWeb.Router.Helpers

  alias BurpWeb.PostView

  def maybe_add(nodes, _, nil, nil), do: nodes
  def maybe_add(nodes, type, attrs, value), do: nodes ++ [{type, attrs, value}]

  def author(nil), do: []

  def author(%Burp.Meta.Blog{} = blog), do: author(blog.author)
  def author(%Burp.Blog.Post{} = post), do: author(post.author)

  def author(%Burp.Meta.Author{} = author) do
    {
      :author,
      nil,
      [
        {:name, nil, author.name},
        {:email, nil, author.email}
      ]
      |> maybe_add(:url, nil, author.url)
    }
  end

  def title(nil), do: gettext("Who knows Wayne?")
  def title(%Burp.Meta.Blog{} = blog), do: {:title, nil, blog.name}

  def subtitle(nil), do: {:subtitle, nil, gettext("Nobody cares what is written here…")}
  def subtitle(blog), do: {:subtitle, nil, blog.description}

  def self_link(conn, _), do: {:link, %{rel: "self", href: post_url(conn, :index)}, nil}

  def updated(nil), do: []
  def updated(post), do: {:updated, nil, Timex.format!(post.updated_at, "{ISO:Extended}")}

  def published(post), do: {:published, nil, Timex.format!(post.published_at, "{ISO:Extended}")}

  def categories([]), do: []

  def categories([head | tags]), do: [{:category, %{term: head.tag_name}, nil} | categories(tags)]

  def entry(conn, post, current_blog) do
    {:safe, cnt} = PostView.as_html(post, post.content)
    {:safe, excerpt} = PostView.as_html(post, post.excerpt)

    {
      :entry,
      nil,
      [
        {:id, nil, post.guid},
        {:title, nil, post.subject},
        updated(post),
        published(post),
        author(post),
        {:link, %{rel: "alternate", href: PostView.posting_url(conn, post)}, nil},
        categories(post.tags),
        {:summary, %{type: "html"}, excerpt},
        {:content, %{type: "html"}, cnt}
      ]
    }
  end

  def entries(_, [], _), do: []

  def entries(conn, [head | posts], current_blog) do
    [entry(conn, head, current_blog) | entries(conn, posts, current_blog)]
  end
end
