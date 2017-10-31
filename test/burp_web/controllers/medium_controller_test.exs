defmodule BurpWeb.MediumControllerTest do
  use BurpWeb.ConnCase

  alias Burp.Media

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:medium) do
    {:ok, medium} = Media.create_medium(@create_attrs)
    medium
  end

  describe "index" do
    test "lists all media", %{conn: conn} do
      conn = get conn, medium_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Media"
    end
  end

  describe "new medium" do
    test "renders form", %{conn: conn} do
      conn = get conn, medium_path(conn, :new)
      assert html_response(conn, 200) =~ "New Medium"
    end
  end

  describe "create medium" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, medium_path(conn, :create), medium: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == medium_path(conn, :show, id)

      conn = get conn, medium_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Medium"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, medium_path(conn, :create), medium: @invalid_attrs
      assert html_response(conn, 200) =~ "New Medium"
    end
  end

  describe "edit medium" do
    setup [:create_medium]

    test "renders form for editing chosen medium", %{conn: conn, medium: medium} do
      conn = get conn, medium_path(conn, :edit, medium)
      assert html_response(conn, 200) =~ "Edit Medium"
    end
  end

  describe "update medium" do
    setup [:create_medium]

    test "redirects when data is valid", %{conn: conn, medium: medium} do
      conn = put conn, medium_path(conn, :update, medium), medium: @update_attrs
      assert redirected_to(conn) == medium_path(conn, :show, medium)

      conn = get conn, medium_path(conn, :show, medium)
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, medium: medium} do
      conn = put conn, medium_path(conn, :update, medium), medium: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Medium"
    end
  end

  describe "delete medium" do
    setup [:create_medium]

    test "deletes chosen medium", %{conn: conn, medium: medium} do
      conn = delete conn, medium_path(conn, :delete, medium)
      assert redirected_to(conn) == medium_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, medium_path(conn, :show, medium)
      end
    end
  end

  defp create_medium(_) do
    medium = fixture(:medium)
    {:ok, medium: medium}
  end
end
