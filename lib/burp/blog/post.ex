defmodule Burp.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Burp.Blog.Post

  @timestamps_opts [
    type: Timex.Ecto.DateTime,
    autogenerate: {Timex.Ecto.DateTime, :autogenerate, []}
  ]

  schema "posts" do
    field(:attrs, :map, default: %{})
    field(:content, :string)
    field(:excerpt, :string)
    field(:format, :string)
    field(:guid, :string)
    field(:posting_format, :string)
    field(:published_at, Timex.Ecto.DateTime)
    field(:slug, :string)
    field(:subject, :string)
    field(:visible, :boolean, default: false)

    belongs_to(:blog, Burp.Meta.Blog)
    belongs_to(:author, Burp.Meta.Author)

    has_many(:comments, Burp.Blog.Comment)
    has_many(:tags, Burp.Blog.Tag)

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs, blog \\ nil, user \\ nil) do
    post
    |> cast(attrs, [
         :slug,
         :visible,
         :subject,
         :excerpt,
         :content,
         :published_at,
         :posting_format
       ])
    |> put_change(:posting_format, "markdown")
    |> put_change(:format, "markdown")
    |> put_change(:published_at, Timex.now())
    |> put_blog(blog)
    |> put_author(user)
    |> update_slug()
    |> put_guid(blog)
    |> validate_required([
         :slug,
         :guid,
         :visible,
         :subject,
         :content,
         :format,
         :published_at,
         :posting_format
       ])
    |> unique_constraint(:slug)
    |> unique_constraint(:guid)
  end

  defp update_slug(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{slug: slug}} ->
        now = Timex.now()
        month = Enum.at([nil] ++ ~w[jan feb mar apr may jun jul aug sep oct nov dec], now.month)
        str = "#{now.year}/#{month}/#{slug}"

        put_change(changeset, :slug, str)

      _ ->
        changeset
    end
  end

  defp put_guid(changeset, nil), do: changeset

  defp put_guid(changeset, blog) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :guid, blog.url <> get_change(changeset, :slug))

      _ ->
        changeset
    end
  end

  defp put_author(changeset, nil), do: changeset

  defp put_author(changeset, author) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :author_id, author.id)

      _ ->
        changeset
    end
  end

  defp put_blog(changeset, nil), do: changeset

  defp put_blog(changeset, blog) do
    case changeset do
      %Ecto.Changeset{valid?: true} ->
        put_change(changeset, :blog_id, blog.id)

      _ ->
        changeset
    end
  end
end
