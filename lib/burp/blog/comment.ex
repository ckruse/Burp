defmodule Burp.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset
  alias Burp.Blog.Comment

  @timestamps_opts [
    type: Timex.Ecto.DateTime,
    autogenerate: {Timex.Ecto.DateTime, :autogenerate, []}
  ]

  schema "comments" do
    field(:attrs, :map, default: %{})
    field(:author, :string)
    field(:content, :string)
    field(:email, :string)
    field(:url, :string)
    field(:visible, :boolean, default: false)

    belongs_to(:post, Burp.Blog.Post)

    timestamps()
  end

  @doc false
  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, [:post_id, :visible, :author, :email, :url, :content])
    |> validate_required([:post_id, :visible, :author, :content])
  end
end