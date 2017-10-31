defmodule BurpWeb.Admin.ConfigController do
  use BurpWeb, :controller

  alias Burp.Meta

  def edit(conn, _params) do
    changeset = Meta.change_blog(conn.assigns[:current_blog])
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"blog" => blog_params}) do
    case Meta.update_blog(conn.assigns[:current_blog], blog_params) do
      {:ok, blog} ->
        conn
        |> put_flash(:info, gettext("Configuration updated successfully."))
        |> redirect(to: admin_config_path(conn, :edit))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
