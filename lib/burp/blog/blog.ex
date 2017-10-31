defmodule Burp.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Burp.Repo

  alias Burp.Blog.Post
  alias Burp.Blog.Comment
  alias Burp.Blog.Tag

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts(blog \\ nil, published \\ true, query_params \\ [order: nil, limit: nil]) do
    from(
      post in Post,
      order_by: [desc: post.inserted_at]
    )
    |> only_published(published)
    |> from_blog(blog)
    |> Burp.PagingApi.set_limit(query_params[:limit])
    |> Burp.OrderApi.set_ordering(query_params[:order], desc: :inserted_at)
    |> Repo.all()
    |> std_post_preloads(published)
  end

  def count_posts(blog \\ nil, published \\ true) do
    from(post in Post)
    |> only_published(published)
    |> from_blog(blog)
    |> select(count("*"))
    |> Repo.one()
  end

  def get_last_post(blog \\ nil, published \\ true) do
    from(
      post in Post,
      order_by: [desc: post.published_at],
      limit: 1
    )
    |> only_published(published)
    |> from_blog(blog)
    |> Repo.one()
    |> std_post_preloads(published)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id, blog \\ nil, published \\ true) do
    from(
      p in Post,
      where: p.id == ^id
    )
    |> only_published(published)
    |> from_blog(blog)
    |> Repo.one!()
    |> std_post_preloads(published)
  end

  def get_post_by_slug!(slug, blog \\ nil, published \\ true) do
    from(
      p in Post,
      where: p.slug == ^slug
    )
    |> only_published(published)
    |> from_blog(blog)
    |> Repo.one!()
    |> std_post_preloads(published)
  end

  defp std_post_preloads(q, published) do
    Repo.preload(q, [
      :author,
      :blog,
      comments: from(Comment, order_by: [asc: :inserted_at]) |> only_published(published),
      tags: from(Tag, order_by: [asc: :tag_name])
    ])
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}, blog, user) do
    %Post{}
    |> Post.changeset(attrs, blog, user)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments(blog \\ nil, published \\ true, query_params \\ [order: nil, limit: nil]) do
    from(comment in Comment, preload: [:post])
    |> only_published(published)
    |> from_blog(blog, :comments)
    |> Burp.PagingApi.set_limit(query_params[:limit])
    |> Burp.OrderApi.set_ordering(query_params[:order], desc: :inserted_at)
    |> Repo.all()
  end

  def count_comments(blog \\ nil, published \\ true) do
    from(comment in Comment)
    |> only_published(published)
    |> from_blog(blog, :comments)
    |> select(count("*"))
    |> Repo.one()
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id, blog \\ nil, published \\ true) do
    from(c in Comment, where: c.id == ^id, preload: [:post])
    |> only_published(published)
    |> from_blog(blog, :comments)
    |> Repo.one!()
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}, post) do
    %Comment{post_id: post.id}
    |> Comment.changeset(attrs)
    |> maybe_moderate(post)
    |> Repo.insert()
  end

  defp maybe_moderate(changeset, post) do
    case post.blog.attrs["comments_moderated"] do
      "yes" ->
        Ecto.Changeset.put_change(changeset, :visible, false)

      _ ->
        Ecto.Changeset.put_change(changeset, :visible, true)
    end
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end

  @doc """
  Returns the list of tags.

  ## Examples

      iex> list_tags()
      [%Tag{}, ...]

  """
  def list_tags do
    Repo.all(Tag)
  end

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the Tag does not exist.

  ## Examples

      iex> get_tag!(123)
      %Tag{}

      iex> get_tag!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tag!(id), do: Repo.get!(Tag, id)

  @doc """
  Creates a tag.

  ## Examples

      iex> create_tag(%{field: value})
      {:ok, %Tag{}}

      iex> create_tag(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tag(attrs \\ %{}) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tag.

  ## Examples

      iex> update_tag(tag, %{field: new_value})
      {:ok, %Tag{}}

      iex> update_tag(tag, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tag(%Tag{} = tag, attrs) do
    tag
    |> Tag.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Tag.

  ## Examples

      iex> delete_tag(tag)
      {:ok, %Tag{}}

      iex> delete_tag(tag)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tag(%Tag{} = tag) do
    Repo.delete(tag)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tag changes.

  ## Examples

      iex> change_tag(tag)
      %Ecto.Changeset{source: %Tag{}}

  """
  def change_tag(%Tag{} = tag) do
    Tag.changeset(tag, %{})
  end

  defp only_published(q, true), do: from(p in q, where: p.visible == true)
  defp only_published(q, _), do: q

  defp only_published(q, true, _), do: where(q, [_, posts], posts.visible == true)
  defp only_published(q, _, _), do: q

  defp from_blog(q, nil), do: q
  defp from_blog(q, blog), do: from(p in q, where: p.blog_id == ^blog.id)
  defp from_blog(q, nil, _), do: q

  defp from_blog(q, blog, :comments),
    do: from(c in q, join: p in Post, on: [id: c.post_id], where: p.blog_id == ^blog.id)

  defp from_blog(q, blog, :tags), do: where(q, [_, posts], posts.blog_id == ^blog.id)

  def list_years(blog, published \\ true) do
    from(
      post in Post,
      select: {fragment("EXTRACT(YEAR FROM inserted_at) AS year"), count("*")},
      group_by: fragment("EXTRACT(YEAR FROM inserted_at)"),
      order_by: fragment("year DESC")
    )
    |> from_blog(blog)
    |> only_published(published)
    |> Repo.all()
  end

  def list_months(year, blog, published \\ true) do
    from(
      post in Post,
      select: {fragment("DATE_TRUNC('month', ?) AS mon", post.inserted_at), count("*")},
      where: fragment("EXTRACT(year from ?) = ?", post.inserted_at, ^year),
      group_by: fragment("DATE_TRUNC('month', ?)", post.inserted_at),
      order_by: fragment("DATE_TRUNC('month', ?)", post.inserted_at)
    )
    |> from_blog(blog)
    |> only_published(published)
    |> Repo.all()
  end

  def list_posts_by_year_and_month(
        year,
        month,
        blog,
        published \\ true,
        query_params \\ [order: nil, limit: nil]
      ) do
    starts = Timex.beginning_of_month(year, month)
    ends = Timex.end_of_month(year, month)

    from(
      post in Post,
      where: post.inserted_at >= ^starts and post.inserted_at <= ^ends,
      order_by: [desc: post.inserted_at]
    )
    |> only_published(published)
    |> from_blog(blog)
    |> Burp.PagingApi.set_limit(query_params[:limit])
    |> Burp.OrderApi.set_ordering(query_params[:order], desc: :inserted_at)
    |> Repo.all()
    |> std_post_preloads(published)
  end

  def list_tags(blog, published \\ true) do
    from(
      tag in Tag,
      select: {fragment("LOWER(?) AS tag_name", tag.tag_name), count("*")},
      inner_join: p in Post,
      where: p.id == tag.post_id,
      group_by: fragment("LOWER(?)", tag.tag_name),
      order_by: fragment("LOWER(?)", tag.tag_name)
    )
    |> from_blog(blog, :tags)
    |> only_published(published, :tags)
    |> Repo.all()
  end

  def list_posts_by_tag(tag, blog, published \\ true, query_params \\ [order: nil, limit: nil]) do
    from(
      post in Post,
      where: post.id in fragment("SELECT post_id FROM tags WHERE LOWER(tag_name) = ?", ^tag),
      order_by: [desc: post.inserted_at]
    )
    |> only_published(published)
    |> from_blog(blog)
    |> Burp.PagingApi.set_limit(query_params[:limit])
    |> Burp.OrderApi.set_ordering(query_params[:order], desc: :inserted_at)
    |> Repo.all()
    |> std_post_preloads(published)
  end
end
