defmodule BurpWeb.SessionController do
  use BurpWeb, :controller

  plug(BurpWeb.Plug.EnsureAnonymous, only: [:new, :create])
  plug(BurpWeb.Plug.EnsureAuthenticatedAction, only: [:delete])

  alias Burp.Meta

  def new(conn, _params) do
    changeset = Meta.login_author(%Meta.Author{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{
        "author" => %{"login" => username, "password" => pass, "remember_me" => remember}
      }) do
    case Meta.authenticate_author(username, pass, conn.assigns[:current_blog]) do
      {:ok, author} ->
        conn =
          case remember do
            "true" ->
              token = Phoenix.Token.sign(BurpWeb.Endpoint, "author", author.id)

              conn
              |> put_resp_cookie("remember_me", token, max_age: 30 * 24 * 60 * 60)

            _ ->
              conn
          end

        conn
        |> put_session(:author_id, author.id)
        |> configure_session(renew: true)
        |> put_flash(:info, gettext("You logged in successfully"))
        |> redirect(to: Routes.post_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, gettext("Username or password wrong"))
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:info, gettext("You logged out successfully"))
    |> delete_resp_cookie("remember_me")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
