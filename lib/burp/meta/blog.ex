defmodule Burp.Meta.Blog do
  use Ecto.Schema
  import Ecto.Changeset
  alias Burp.Meta.Blog


  schema "blogs" do
    field :attrs, :map, default: %{}
    field :description, :string
    field :host, :string
    field :image_url, :string
    field :keywords, :string
    field :lang, :string
    field :name, :string
    field :url, :string

    belongs_to :author, Burp.Meta.Author
    has_many :posts, Burp.Blog.Post
    has_many :media, Burp.Media.Medium

    timestamps()
  end

  @doc false
  def changeset(%Blog{} = blog, attrs) do
    blog
    |> cast(attrs, [:name, :description, :keywords, :url, :image_url, :lang, :host, :attrs, :author_id])
    |> validate_required([:name, :description, :keywords, :url, :image_url, :lang, :host, :author_id])
    |> unique_constraint(:host)
  end
end
