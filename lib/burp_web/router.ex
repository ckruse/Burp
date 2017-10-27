defmodule BurpWeb.Router do
  use BurpWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)

    plug(BurpWeb.Plug.CurrentUser)
    plug(BurpWeb.Plug.CurrentBlog)
    plug(BurpWeb.Plug.SetLocale)
  end

  pipeline :require_login do
    plug(BurpWeb.Plug.EnsureAuthenticated)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/admin", as: :admin, alias: BurpWeb.Admin do
    pipe_through([:browser, :require_login])

    resources("/posts", PostController, except: [:show])
    resources("/comments", CommentController, except: [:show, :new, :create])
    resources("/media", MediumController, except: [:show])
  end

  scope "/", BurpWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/login", SessionController, :new)
    post("/login", SessionController, :create)
    get("/logout", SessionController, :delete)

    get("/media/:slug", MediumController, :show)

    get("/", PostController, :index)

    get("/tags", TagController, :index)
    get("/tags/:tag", TagController, :show)

    get("/feed.atom", PostController, :index_atom)
    get("/feed.rss", PostController, :index_rss)
    get("/rss-feed", PostController, :redirect_rss)
    get("/atom-feed", PostController, :redirect_atom)

    get("/archive", ArchiveController, :years)
    get("/:year", ArchiveController, :months)
    get("/:year/:mon", ArchiveController, :index)

    get("/:year/:mon/:slug", PostController, :show)
    post("/:year/:mon/:slug", CommentController, :create)
  end

  # Other scopes may use custom stacks.
  # scope "/api", BurpWeb do
  #   pipe_through :api
  # end
end
