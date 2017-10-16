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
  def list_media do
    Repo.all(Medium)
  end

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

  @doc """
  Creates a medium.

  ## Examples

      iex> create_medium(%{field: value})
      {:ok, %Medium{}}

      iex> create_medium(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_medium(attrs \\ %{}) do
    %Medium{}
    |> Medium.changeset(attrs)
    |> Repo.insert()
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
    medium
    |> Medium.changeset(attrs)
    |> Repo.update()
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
    Repo.delete(medium)
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
end
