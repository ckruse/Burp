defmodule Burp.Meta.Author do
  use Ecto.Schema
  import Ecto.Changeset
  alias Burp.Meta.Author


  schema "authors" do
    field :admin, :boolean, default: false
    field :email, :string
    field :encrypted_password, :string, default: ""
    field :url, :string
    field :username, :string

    has_many :blogs, Burp.Meta.Blog
    has_many :posts, Burp.Blog.Post

    timestamps()
  end

  @doc false
  def changeset(%Author{} = author, attrs) do
    author
    |> cast(attrs, [:username, :email, :url, :encrypted_password, :admin])
    |> validate_required([:username, :email, :url, :admin])
    |> unique_constraint(:username)
    |> unique_constraint(:email)
  end
end
