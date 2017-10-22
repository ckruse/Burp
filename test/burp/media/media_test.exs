defmodule Burp.MediaTest do
  use Burp.DataCase

  alias Burp.Media

  describe "media" do
    alias Burp.Media.Medium

    test "list_media/0 returns all media" do
      medium = %{
        insert(:medium)
        | blog: %Ecto.Association.NotLoaded{
            __field__: :blog,
            __cardinality__: :one,
            __owner__: Medium
          }
      }

      assert Media.list_media() == [medium]
    end

    test "get_medium!/1 returns the medium with given id" do
      medium = %{
        insert(:medium)
        | blog: %Ecto.Association.NotLoaded{
            __field__: :blog,
            __cardinality__: :one,
            __owner__: Medium
          }
      }

      assert Media.get_medium!(medium.id) == medium
    end

    test "create_medium/1 with valid data creates a medium" do
      blog = insert(:blog)
      attrs = params_for(:medium, blog_id: blog.id)
      assert {:ok, %Medium{} = medium} = Media.create_medium(attrs)
      assert medium.media_type == attrs[:media_type]
      assert medium.name == attrs[:name]
      assert medium.path == attrs[:path]
      assert medium.url == attrs[:url]
    end

    test "create_medium/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Media.create_medium(%{})
    end

    test "update_medium/2 with valid data updates the medium" do
      medium = insert(:medium)
      assert {:ok, medium} = Media.update_medium(medium, %{name: "foo bar"})
      assert %Medium{} = medium
      assert medium.name == "foo bar"
    end

    test "update_medium/2 with invalid data returns error changeset" do
      medium = %{
        insert(:medium)
        | blog: %Ecto.Association.NotLoaded{
            __field__: :blog,
            __cardinality__: :one,
            __owner__: Medium
          }
      }

      assert {:error, %Ecto.Changeset{}} = Media.update_medium(medium, %{name: nil})
      assert medium == Media.get_medium!(medium.id)
    end

    test "delete_medium/1 deletes the medium" do
      medium = insert(:medium)
      assert {:ok, %Medium{}} = Media.delete_medium(medium)
      assert_raise Ecto.NoResultsError, fn -> Media.get_medium!(medium.id) end
    end

    test "change_medium/1 returns a medium changeset" do
      medium = insert(:medium)
      assert %Ecto.Changeset{} = Media.change_medium(medium)
    end
  end
end
