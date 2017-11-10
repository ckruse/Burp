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

    field(:tags_str, :string, virtual: true)

    belongs_to(:blog, Burp.Meta.Blog)
    belongs_to(:author, Burp.Meta.Author)

    has_many(:comments, Burp.Blog.Comment)
    has_many(:tags, Burp.Blog.Tag, on_delete: :delete_all, on_replace: :delete)

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
         :posting_format,
         :tags_str
       ])
    |> put_change(:posting_format, "markdown")
    |> put_change(:format, "markdown")
    |> maybe_reset_published_at()
    |> put_blog(blog)
    |> put_author(user)
    |> update_slug()
    |> put_guid(blog)
    |> put_tags()
    |> put_tags_str()
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
    |> validate_length(:subject, max: 255)
    |> validate_length(:slug, max: 255)
    |> unique_constraint(:slug)
    |> unique_constraint(:guid)
  end

  defp put_tags(%Ecto.Changeset{valid?: true, changes: %{tags_str: tags_str}} = changeset)
       when tags_str == nil or tags_str == "",
       do: put_assoc(changeset, :tags, [])

  defp put_tags(%Ecto.Changeset{valid?: true, changes: %{tags_str: tags_str}} = changeset) do
    tags = String.split(tags_str, ~r{\s*,\s*}, trim: true)
    put_assoc(changeset, :tags, Enum.map(tags, &%Burp.Blog.Tag{tag_name: &1}))
  end

  defp put_tags(changeset), do: changeset

  defp put_tags_str(%Ecto.Changeset{valid?: true} = changeset) do
    case Ecto.Changeset.get_field(changeset, :tags) do
      v when v == nil or v == [] ->
        put_change(changeset, :tags_str, "")

      tags ->
        str = Enum.map(tags, & &1.tag_name) |> Enum.join(", ")
        put_change(changeset, :tags_str, str)
    end
  end

  defp put_tags_str(changeset), do: changeset

  defp update_slug(%Ecto.Changeset{valid?: true, changes: %{slug: slug}} = changeset) do
    now = Timex.now()
    month = Enum.at([nil] ++ ~w[jan feb mar apr may jun jul aug sep oct nov dec], now.month)
    str = "#{now.year}/#{month}/#{slug}"

    put_change(changeset, :slug, str)
  end

  defp update_slug(changeset), do: changeset

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

  # set published_at on creation
  defp maybe_reset_published_at(%Ecto.Changeset{valid?: true, action: :insert} = changeset),
    do: put_change(changeset, :published_at, Timex.now())

  # set published_at on visibility change
  defp maybe_reset_published_at(%Ecto.Changeset{valid?: true, changes: %{visible: true}} = changeset),
    do: put_change(changeset, :published_at, Timex.now())

  # don't touch published_at otherwise
  defp maybe_reset_published_at(changeset), do: changeset
end
