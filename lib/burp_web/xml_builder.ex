defmodule BurpWeb.XmlBuilder do
  import BurpWeb.Gettext
  alias BurpWeb.Helpers, as: WebHelpers

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

  def title(nil), do: {:title, nil, gettext("Who knows Wayne?")}
  def title(%Burp.Meta.Blog{} = blog), do: {:title, nil, blog.name}

  def description(type, nil), do: {type, nil, gettext("Nobody cares what is written here…")}
  def description(type, blog), do: {type, nil, blog.description}

  def self_link(conn, current_blog),
    do: {:link, %{rel: "self", href: "#{WebHelpers.root_url(conn, current_blog)}feed.atom"}, nil}

  def updated(nil), do: []
  def updated(post), do: {:updated, nil, Timex.format!(post.updated_at, "{ISO:Extended}")}

  def published(post), do: {:published, nil, Timex.format!(post.published_at, "{ISO:Extended}")}

  def categories([]), do: []

  def categories([head | tags]), do: [{:category, %{term: head.tag_name}, nil} | categories(tags)]

  def entry(conn, post, _current_blog) do
    {:safe, cnt} = WebHelpers.as_html(post, post.content)

    {:safe, excerpt} =
      if is_nil(post.excerpt) or post.excerpt == "",
        do: {:safe, nil},
        else: WebHelpers.as_html(post, post.excerpt)

    children = children_for_entry(conn, post, excerpt, cnt)

    {:entry, nil, children}
  end

  defp children_for_entry(conn, post, nil, cnt) do
    [
      {:id, nil, post.guid},
      {:title, nil, post.subject},
      updated(post),
      published(post),
      author(post),
      {:link, %{rel: "alternate", href: WebHelpers.posting_url(conn, post)}, nil},
      categories(post.tags),
      {:content, %{type: "html"}, cnt}
    ]
  end

  defp children_for_entry(conn, post, excerpt, cnt) do
    [
      {:id, nil, post.guid},
      {:title, nil, post.subject},
      updated(post),
      published(post),
      author(post),
      {:link, %{rel: "alternate", href: WebHelpers.posting_url(conn, post)}, nil},
      categories(post.tags),
      {:summary, %{type: "html"}, excerpt},
      {:content, %{type: "html"}, cnt}
    ]
  end

  def entries(_, [], _), do: []

  def entries(conn, [head | posts], current_blog) do
    [entry(conn, head, current_blog) | entries(conn, posts, current_blog)]
  end

  def item(conn, post, _) do
    {:safe, cnt} = WebHelpers.as_html(post, post.content)

    {
      :item,
      nil,
      [
        {:title, nil, post.subject},
        {:description, nil, cnt},
        {:pubDate, nil, Timex.format!(post.published_at, "{RFC1123}")},
        {:link, nil, WebHelpers.posting_url(conn, post)},
        {:guid, nil, post.guid}
      ]
    }
  end

  def items(_, [], _), do: []

  def items(conn, [head | posts], current_blog) do
    [item(conn, head, current_blog) | items(conn, posts, current_blog)]
  end
end
