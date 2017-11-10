defmodule BurpWeb.Helpers do
  use Phoenix.HTML

  @doc """
  generates a „sub-form“ in a different namespace: the input fields will be prefixed
  with that namespace. If i.e. called with `field` set to `foo[bar]` the generated
  field names look like this: `foo[bar][baz]`
  """
  def sub_inputs(form, field, _options \\ [], fun) do
    # options =
    #   form.options
    #   |> Keyword.take([:multipart])
    #   |> Keyword.merge(options)

    attr = Map.get(form.data, field) || %{}

    symbolized_attr =
      Enum.reduce(Map.keys(attr), %{}, fn key, map ->
        Map.put(map, String.to_atom(key), attr[key])
      end)

    types = Enum.reduce(Map.keys(symbolized_attr), %{}, fn key, map -> Map.put(map, key, :string) end)

    changeset = Ecto.Changeset.cast({symbolized_attr, types}, form.params, Map.keys(symbolized_attr))

    forms = Phoenix.HTML.FormData.to_form(changeset, as: form.name <> "[#{field}]")

    fun.(forms)
  end

  defp scheme(), do: Application.get_env(:burp, :scheme)

  defp get_port(conn) do
    s = scheme()
    port = Application.get_env(:burp, :port) || conn.port

    cond do
      (s == "http" && port == 80) || (s == "https" && port == "443") ->
        ""

      true ->
        ":#{port}"
    end
  end

  def root_url(conn, blog \\ nil)
  def root_url(conn, nil), do: "#{scheme()}://#{conn.host}#{get_port(conn)}/"
  def root_url(conn, %Burp.Meta.Blog{url: url}), do: "#{url}"

  def comment_url(conn, comment), do: posting_url(conn, comment.post) <> "#comment-#{comment.id}"

  def comment_url(conn, comment, post), do: posting_url(conn, post) <> "#comment-#{comment.id}"

  def new_comment_url(conn, post), do: posting_url(conn, post)

  def posting_url(conn, post), do: root_url(conn, post.blog) <> post.slug

  def posting_path(conn, post), do: BurpWeb.Router.Helpers.post_path(conn, :index) <> post.slug

  alias Burp.Blog.Post
  alias Burp.Blog.Comment

  def as_html(%Post{posting_format: "html"}, html), do: {:safe, html}
  def as_html(%Post{}, markdown), do: {:safe, Cmark.to_html(markdown)}
  def as_html(%Comment{format: "html"}, html), do: {:safe, Cmark.to_html(html)}
  def as_html(%Comment{}, markdown), do: {:safe, Cmark.to_html(markdown, [:safe, :smart])}

  def valid_url(url) do
    uri = URI.parse(url)
    uri.scheme == "http" || uri.scheme == "https"
  end

  def iso_date(time) do
    time
    |> Timex.set(microsecond: {0, 0})
    |> Timex.format!("{ISO:Extended}")
  end
end
