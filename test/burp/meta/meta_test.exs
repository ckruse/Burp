defmodule Burp.MetaTest do
  use Burp.DataCase

  alias Burp.Meta

  describe "authors" do
    alias Burp.Meta.Author

    test "list_authors/0 returns all authors" do
      author = insert(:author)
      assert Meta.list_authors() == [author]
    end

    test "get_author!/1 returns the author with given id" do
      author = insert(:author)
      assert Meta.get_author!(author.id) == author
    end

    test "create_author/1 with valid data creates a author" do
      params = params_for(:author)
      assert {:ok, %Author{} = author} = Meta.create_author(params)
      assert author.admin == params[:admin]
      assert author.email == params[:email]
      assert author.url == params[:url]
      assert author.username == params[:username]
    end

    test "create_author/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meta.create_author(%{})
    end

    test "update_author/2 with valid data updates the author" do
      author = insert(:author)
      assert {:ok, new_author} = Meta.update_author(author, %{username: "foobar"})
      assert %Author{} = new_author
      assert new_author.admin == author.admin
      assert new_author.email == author.email
      assert new_author.url == author.url
      assert new_author.username == "foobar"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = insert(:author)
      assert {:error, %Ecto.Changeset{}} = Meta.update_author(author, %{username: ""})
      assert author == Meta.get_author!(author.id)
    end

    test "delete_author/1 deletes the author" do
      author = insert(:author)
      assert {:ok, %Author{}} = Meta.delete_author(author)
      assert_raise Ecto.NoResultsError, fn -> Meta.get_author!(author.id) end
    end

    test "change_author/1 returns a author changeset" do
      author = insert(:author)
      assert %Ecto.Changeset{} = Meta.change_author(author)
    end
  end

  describe "blogs" do
    alias Burp.Meta.Blog

    test "list_blogs/0 returns all blogs" do
      blog = insert(:blog)
      assert Meta.list_blogs() == [blog]
    end

    test "get_blog!/1 returns the blog with given id" do
      blog = insert(:blog)
      assert Meta.get_blog!(blog.id) == blog
    end

    test "create_blog/1 with valid data creates a blog" do
      params = params_for(:blog, author: insert(:author))
      assert {:ok, %Blog{} = blog} = Meta.create_blog(params)
      assert blog.attrs == params[:attrs]
      assert blog.description == params[:description]
      assert blog.host == params[:host]
      assert blog.image_url == params[:image_url]
      assert blog.keywords == params[:keywords]
      assert blog.lang == params[:lang]
      assert blog.name == params[:name]
      assert blog.url == params[:url]
    end

    test "create_blog/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meta.create_blog(%{})
    end

    test "update_blog/2 with valid data updates the blog" do
      blog = insert(:blog)
      assert {:ok, new_blog} = Meta.update_blog(blog, %{name: "foobar"})
      assert %Blog{} = new_blog
      assert new_blog.attrs == blog.attrs
      assert new_blog.description == blog.description
      assert new_blog.host == blog.host
      assert new_blog.image_url == blog.image_url
      assert new_blog.keywords == blog.keywords
      assert new_blog.lang == blog.lang
      assert new_blog.name == "foobar"
      assert new_blog.url == blog.url
    end

    test "update_blog/2 with invalid data returns error changeset" do
      blog = insert(:blog)
      assert {:error, %Ecto.Changeset{}} = Meta.update_blog(blog, %{name: ""})
      assert blog == Meta.get_blog!(blog.id)
    end

    test "delete_blog/1 deletes the blog" do
      blog = insert(:blog)
      assert {:ok, %Blog{}} = Meta.delete_blog(blog)
      assert_raise Ecto.NoResultsError, fn -> Meta.get_blog!(blog.id) end
    end

    test "change_blog/1 returns a blog changeset" do
      blog = insert(:blog)
      assert %Ecto.Changeset{} = Meta.change_blog(blog)
    end
  end
end
