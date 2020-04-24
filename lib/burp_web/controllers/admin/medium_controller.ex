defmodule BurpWeb.Admin.MediumController do
  use BurpWeb, :controller

  alias Burp.Media
  alias Burp.Media.Medium

  def index(conn, _params) do
    media = Media.list_media(conn.assigns[:current_blog])
    render(conn, "index.html", media: media)
  end

  def new(conn, _params) do
    changeset = Media.change_medium(%Medium{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"medium" => medium_params}) do
    case Media.create_medium(medium_params, conn.assigns[:current_blog]) do
      {:ok, medium} ->
        conn
        |> put_flash(:info, gettext("Medium created successfully."))
        |> redirect(to: Routes.admin_medium_path(conn, :edit, medium))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    medium = Media.get_medium!(id)
    render(conn, "show.html", medium: medium)
  end

  def edit(conn, %{"id" => slug}) do
    medium = Media.get_medium_by_slug!(slug)
    changeset = Media.change_medium(medium)
    render(conn, "edit.html", medium: medium, changeset: changeset)
  end

  def update(conn, %{"id" => slug, "medium" => medium_params}) do
    medium = Media.get_medium_by_slug!(slug)

    case Media.update_medium(medium, medium_params) do
      {:ok, medium} ->
        conn
        |> put_flash(:info, gettext("Medium updated successfully."))
        |> redirect(to: Routes.admin_medium_path(conn, :edit, medium))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", medium: medium, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => slug}) do
    medium = Media.get_medium_by_slug!(slug)
    {:ok, _medium} = Media.delete_medium(medium)

    conn
    |> put_flash(:info, gettext("Medium deleted successfully."))
    |> redirect(to: Routes.admin_medium_path(conn, :index))
  end
end
