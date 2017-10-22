defmodule Burp.Media.Medium do
  use Ecto.Schema
  import Ecto.Changeset
  alias Burp.Media.Medium

  schema "media" do
    field(:media_type, :string)
    field(:name, :string)
    field(:path, :string)
    field(:url, :string)

    belongs_to(:blog, Burp.Meta.Blog)

    timestamps()
  end

  @doc false
  def changeset(%Medium{} = medium, attrs) do
    medium
    |> cast(attrs, [:name, :media_type, :url, :path, :blog_id])
    |> validate_required([:name, :media_type, :url, :path, :blog_id])
  end
end
