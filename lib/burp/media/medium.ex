defmodule Burp.Media.Medium do
  use Ecto.Schema
  import Ecto.Changeset
  alias Burp.Media.Medium

  @derive {Phoenix.Param, key: :url}

  schema "media" do
    field(:media_type, :string)
    field(:name, :string)
    field(:path, :string)
    field(:url, :string)

    belongs_to(:blog, Burp.Meta.Blog)
  end

  @doc false
  def changeset(%Medium{} = medium, attrs, blog \\ nil) do
    medium
    |> cast(attrs, [:name, :media_type, :url, :path, :blog_id])
    |> put_blog(blog)
    |> validate_required([:name, :media_type, :url, :path])
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
