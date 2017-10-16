defmodule Burp.BlogTest do
  use Burp.DataCase

  alias Burp.Blog

  describe "posts" do
    alias Burp.Blog.Post

    test "list_posts/0 returns all posts" do
      post = insert(:post)
      assert Blog.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = insert(:post)
      assert Blog.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      params = params_for(:post)
      assert {:ok, %Post{} = new_post} = Blog.create_post(params)
      assert new_post.content == params[:content]
      assert new_post.format == params[:format]
      assert new_post.guid == params[:guid]
      assert new_post.posting_format == params[:posting_format]
      assert new_post.published_at == params[:published_at]
      assert new_post.slug == params[:slug]
      assert new_post.subject == params[:subject]
      assert new_post.visible == params[:visible]
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_post(%{})
    end

    test "update_post/2 with valid data updates the post" do
      post = insert(:post)
      assert {:ok, new_post} = Blog.update_post(post, %{subject: "foo bar"})
      assert %Post{} = new_post
      assert new_post.content == post.content
      assert new_post.format == post.format
      assert new_post.guid == post.guid
      assert new_post.posting_format == post.posting_format
      assert new_post.published_at == post.published_at
      assert new_post.slug == post.slug
      assert new_post.subject == "foo bar"
      assert new_post.visible == post.visible
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = insert(:post)
      assert {:error, %Ecto.Changeset{}} = Blog.update_post(post, %{subject: ""})
      assert post == Blog.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = insert(:post)
      assert {:ok, %Post{}} = Blog.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = insert(:post)
      assert %Ecto.Changeset{} = Blog.change_post(post)
    end
  end

  describe "comments" do
    alias Burp.Blog.Comment

    test "list_comments/0 returns all comments" do
      comment = %{
        insert(:comment) | post: %Ecto.Association.NotLoaded{__field__: :post, __cardinality__: :one, __owner__: Comment}
      }
      assert Blog.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = %{insert(:comment) | post: %Ecto.Association.NotLoaded{__field__: :post, __cardinality__: :one, __owner__: Comment}}
      assert Blog.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      post = insert(:post)
      attrs = params_for(:comment, post_id: post.id)
      assert {:ok, %Comment{} = comment} = Blog.create_comment(attrs)
      assert comment.author == attrs[:author]
      assert comment.content == attrs[:content]
      assert comment.email == attrs[:email]
      assert comment.url == attrs[:url]
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_comment(%{})
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = %{insert(:comment) | post: %Ecto.Association.NotLoaded{__field__: :post, __cardinality__: :one, __owner__: Comment}}
      assert {:ok, comment} = Blog.update_comment(comment, %{author: "Leia Skywalker", content: "For the rebellion!", email: "leia@example.org", url: "https://aldebaran.planet"})
      assert %Comment{} = comment
      assert comment.author == "Leia Skywalker"
      assert comment.content == "For the rebellion!"
      assert comment.email == "leia@example.org"
      assert comment.url == "https://aldebaran.planet"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = %{insert(:comment) | post: %Ecto.Association.NotLoaded{__field__: :post, __cardinality__: :one, __owner__: Comment}}
      assert {:error, %Ecto.Changeset{}} = Blog.update_comment(comment, %{content: nil})
      assert comment == Blog.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = insert(:comment)
      assert {:ok, %Comment{}} = Blog.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = insert(:comment)
      assert %Ecto.Changeset{} = Blog.change_comment(comment)
    end
  end

  describe "tags" do
    alias Burp.Blog.Tag

    test "list_tags/0 returns all tags" do
      tag = %{insert(:tag) | post: %Ecto.Association.NotLoaded{__field__: :post, __cardinality__: :one, __owner__: Tag}}
      assert Blog.list_tags() == [tag]
    end

    test "get_tag!/1 returns the tag with given id" do
      tag = %{insert(:tag) | post: %Ecto.Association.NotLoaded{__field__: :post, __cardinality__: :one, __owner__: Tag}}
      assert Blog.get_tag!(tag.id) == tag
    end

    test "create_tag/1 with valid data creates a tag" do
      post = insert(:post)
      attrs = params_for(:tag, post_id: post.id)
      assert {:ok, %Tag{} = tag} = Blog.create_tag(attrs)
      assert tag.tag_name == attrs[:tag_name]
    end

    test "create_tag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_tag(%{})
    end

    test "update_tag/2 with valid data updates the tag" do
      tag = %{insert(:tag) | post: %Ecto.Association.NotLoaded{__field__: :post, __cardinality__: :one, __owner__: Tag}}
      assert {:ok, tag} = Blog.update_tag(tag, %{tag_name: "foo bar"})
      assert %Tag{} = tag
      assert tag.tag_name == "foo bar"
    end

    test "update_tag/2 with invalid data returns error changeset" do
      tag = %{insert(:tag) | post: %Ecto.Association.NotLoaded{__field__: :post, __cardinality__: :one, __owner__: Tag}}
      assert {:error, %Ecto.Changeset{}} = Blog.update_tag(tag, %{tag_name: nil})
      assert tag == Blog.get_tag!(tag.id)
    end

    test "delete_tag/1 deletes the tag" do
      tag = insert(:tag)
      assert {:ok, %Tag{}} = Blog.delete_tag(tag)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_tag!(tag.id) end
    end

    test "change_tag/1 returns a tag changeset" do
      tag = insert(:tag)
      assert %Ecto.Changeset{} = Blog.change_tag(tag)
    end
  end
end
