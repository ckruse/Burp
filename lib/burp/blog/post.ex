defmodule Burp.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Burp.Blog.Post


  schema "posts" do
    field :attrs, :map, default: %{}
    field :content, :string
    field :excerpt, :string
    field :format, :string
    field :guid, :string
    field :posting_format, :string
    field :published_at, :naive_datetime
    field :slug, :string
    field :subject, :string
    field :visible, :boolean, default: false

    belongs_to :blog, Burp.Meta.Blog
    belongs_to :author, Burp.Meta.Author

    has_many :comments, Burp.Blog.Comment
    has_many :tags, Burp.Blog.Tag

    timestamps()
  end

  @doc false
  def changeset(%Post{} = post, attrs) do
    post
    |> cast(attrs, [:slug, :guid, :visible, :subject, :excerpt, :content, :format, :published_at, :posting_format])
    |> validate_required([:slug, :guid, :visible, :subject, :content, :format, :published_at, :posting_format])
    |> unique_constraint(:slug)
    |> unique_constraint(:guid)
  end
end
