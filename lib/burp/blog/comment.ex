defmodule Burp.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Burp.Blog.Comment

  @timestamps_opts [type: :utc_datetime]

  schema "comments" do
    field(:attrs, :map, default: %{})
    field(:author, :string)
    field(:content, :string)
    field(:email, :string)
    field(:url, :string)
    field(:visible, :boolean, default: false)
    field(:format, :string, default: "markdown")

    belongs_to(:post, Burp.Blog.Post)

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:post_id, :visible, :author, :email, :url, :content])
    |> validate_required([:post_id, :visible, :author, :content])
    |> validate_length(:author, max: 255)
    |> validate_length(:email, max: 255)
    |> validate_length(:url, max: 255)
    |> validate_length(:content, max: 12288)
  end
end
