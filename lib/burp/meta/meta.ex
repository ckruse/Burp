defmodule Burp.Meta do
  @moduledoc """
  The Meta context.
  """

  import Ecto.Query, warn: false
  alias Burp.Repo

  alias Burp.Meta.Author

  @doc """
  Returns the list of authors.

  ## Examples

      iex> list_authors()
      [%Author{}, ...]

  """
  def list_authors do
    Repo.all(Author)
  end

  @doc """
  Gets a single author.

  Raises `Ecto.NoResultsError` if the Author does not exist.

  ## Examples

      iex> get_author!(123)
      %Author{}

      iex> get_author!(456)
      ** (Ecto.NoResultsError)

  """
  def get_author!(id), do: Repo.get!(Author, id)

  @doc """
  Creates a author.

  ## Examples

      iex> create_author(%{field: value})
      {:ok, %Author{}}

      iex> create_author(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_author(attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a author.

  ## Examples

      iex> update_author(author, %{field: new_value})
      {:ok, %Author{}}

      iex> update_author(author, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Author.

  ## Examples

      iex> delete_author(author)
      {:ok, %Author{}}

      iex> delete_author(author)
      {:error, %Ecto.Changeset{}}

  """
  def delete_author(%Author{} = author) do
    Repo.delete(author)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking author changes.

  ## Examples

      iex> change_author(author)
      %Ecto.Changeset{source: %Author{}}

  """
  def change_author(%Author{} = author) do
    Author.changeset(author, %{})
  end

  def login_author(%Author{} = author) do
    Author.login_changeset(author, %{})
  end

  def authenticate_author(login, password, blog) do
    author = get_author_by_username_or_email_and_blog(login, blog)

    cond do
      author && Comeonin.Bcrypt.checkpw(password, author.encrypted_password) ->
        {:ok, author}

      author ->
        {:error, Author.login_changeset(author, %{"login" => login, "password" => password})}

      true ->
        # just waste some time for timing sidechannel attacks
        Comeonin.Bcrypt.dummy_checkpw()
        {:error, Author.login_changeset(%Author{}, %{"login" => login, "password" => password})}
    end
  end

  def get_author_by_username_or_email_and_blog(login, nil) do
    from(
      author in Author,
      where: (fragment("lower(?)", author.email) == fragment("lower(?)", ^login) or
                fragment("lower(?)", author.username) == fragment("lower(?)", ^login)) and
        author.admin == true
    )
    |> Repo.one()
  end

  def get_author_by_username_or_email_and_blog(login, blog) do
    from(
      author in Author,
      where: (fragment("lower(?)", author.email) == fragment("lower(?)", ^login) or
                fragment("lower(?)", author.username) == fragment("lower(?)", ^login)) and
        (author.id == ^blog.author_id or author.admin == true)
    )
    |> Repo.one()
  end

  alias Burp.Meta.Blog

  @doc """
  Returns the list of blogs.

  ## Examples

      iex> list_blogs()
      [%Blog{}, ...]

  """
  def list_blogs do
    Repo.all(Blog)
    |> Repo.preload(:author)
  end

  @doc """
  Gets a single blog.

  Raises `Ecto.NoResultsError` if the Blog does not exist.

  ## Examples

      iex> get_blog!(123)
      %Blog{}

      iex> get_blog!(456)
      ** (Ecto.NoResultsError)

  """
  def get_blog!(id), do: Repo.get!(Blog, id) |> Repo.preload(:author)

  def get_blog_by_host(host) do
    Repo.get_by(Blog, host: host) |> Repo.preload(:author)
  end

  @doc """
  Creates a blog.

  ## Examples

      iex> create_blog(%{field: value})
      {:ok, %Blog{}}

      iex> create_blog(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_blog(attrs \\ %{}) do
    %Blog{}
    |> Blog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a blog.

  ## Examples

      iex> update_blog(blog, %{field: new_value})
      {:ok, %Blog{}}

      iex> update_blog(blog, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_blog(%Blog{} = blog, attrs) do
    blog
    |> Blog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Blog.

  ## Examples

      iex> delete_blog(blog)
      {:ok, %Blog{}}

      iex> delete_blog(blog)
      {:error, %Ecto.Changeset{}}

  """
  def delete_blog(%Blog{} = blog) do
    Repo.delete(blog)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking blog changes.

  ## Examples

      iex> change_blog(blog)
      %Ecto.Changeset{source: %Blog{}}

  """
  def change_blog(%Blog{} = blog) do
    Blog.changeset(blog, %{})
  end
end
