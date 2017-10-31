defmodule Burp.Media do
  @moduledoc """
  The Media context.
  """

  import Ecto.Query, warn: false
  alias Burp.Repo

  alias Burp.Media.Medium

  @doc """
  Returns the list of media.

  ## Examples

      iex> list_media()
      [%Medium{}, ...]

  """
  def list_media(blog \\ nil) do
    from(medium in Medium, order_by: [asc: :name])
    |> from_blog(blog)
    |> Repo.all()
  end

  defp from_blog(q, nil), do: q
  defp from_blog(q, blog), do: from(p in q, where: p.blog_id == ^blog.id)

  @doc """
  Gets a single medium.

  Raises `Ecto.NoResultsError` if the Medium does not exist.

  ## Examples

      iex> get_medium!(123)
      %Medium{}

      iex> get_medium!(456)
      ** (Ecto.NoResultsError)

  """
  def get_medium!(id), do: Repo.get!(Medium, id)

  def get_medium_by_slug!(slug), do: Repo.get_by!(Medium, url: slug)

  @doc """
  Creates a medium.

  ## Examples

      iex> create_medium(%{field: value})
      {:ok, %Medium{}}

      iex> create_medium(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_medium(attrs \\ %{}, blog) do
    {:ok, fname} = copy_file(attrs["file"])

    ret =
      %Medium{path: fname, url: attrs["file"].filename, media_type: attrs["file"].content_type}
      |> Medium.changeset(attrs, blog)
      |> Repo.insert()

    case ret do
      {:ok, medium} ->
        {:ok, medium}

      {:error, changeset} ->
        remove_file(%Medium{path: fname})
        {:error, changeset}
    end
  end

  @doc """
  Updates a medium.

  ## Examples

      iex> update_medium(medium, %{field: new_value})
      {:ok, %Medium{}}

      iex> update_medium(medium, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_medium(%Medium{} = medium, attrs) do
    ret =
      medium
      |> Medium.changeset(attrs)
      |> Repo.update()

    case ret do
      {:ok, medium} ->
        if attrs["file"] do
          File.cp!(attrs["file"].path, "#{storage_dir()}/#{medium.path}")
        end

        {:ok, medium}

      {:error, changeset} ->
        {:error, changeset}
    end
  end

  @doc """
  Deletes a Medium.

  ## Examples

      iex> delete_medium(medium)
      {:ok, %Medium{}}

      iex> delete_medium(medium)
      {:error, %Ecto.Changeset{}}

  """
  def delete_medium(%Medium{} = medium) do
    case Repo.delete(medium) do
      {:ok, medium} ->
        remove_file(medium)
        {:ok, medium}

      ret ->
        ret
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking medium changes.

  ## Examples

      iex> change_medium(medium)
      %Ecto.Changeset{source: %Medium{}}

  """
  def change_medium(%Medium{} = medium) do
    Medium.changeset(medium, %{})
  end

  defp storage_dir(), do: Application.get_env(:burp, :storage_path)
  def filename(medium), do: "#{storage_dir()}/#{medium.path}"

  def copy_file(upload) do
    fname = Ecto.UUID.generate()
    File.cp!(upload.path, "#{storage_dir()}/#{fname}")

    {:ok, fname}
  end

  def remove_file(medium), do: File.rm!(filename(medium))
end
