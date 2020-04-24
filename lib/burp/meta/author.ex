defmodule Burp.Meta.Author do
  use Ecto.Schema
  import Ecto.Changeset
  alias Burp.Meta.Author

  @timestamps_opts [type: :utc_datetime]

  schema "authors" do
    field(:admin, :boolean, default: false)
    field(:email, :string)
    field(:encrypted_password, :string, default: "")
    field(:url, :string)
    field(:username, :string)
    field(:name, :string)

    field(:login, :string, virtual: true)
    field(:password, :string, virtual: true)

    has_many(:blogs, Burp.Meta.Blog)
    has_many(:posts, Burp.Blog.Post)

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

  @doc false
  def login_changeset(%Author{} = author, attrs) do
    author
    |> cast(attrs, [:login, :password])
    |> validate_required([:login, :password])
  end
end
