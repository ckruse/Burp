defmodule Burp.Blog.Tag do
  use Ecto.Schema
  import Ecto.Changeset
  alias Burp.Blog.Tag


  schema "tags" do
    field :tag_name, :string
    belongs_to :post, Burp.Blog.Post
  end

  @doc false
  def changeset(%Tag{} = tag, attrs) do
    tag
    |> cast(attrs, [:tag_name, :post_id])
    |> validate_required([:tag_name, :post_id])
  end
end
