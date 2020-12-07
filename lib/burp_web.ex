defmodule BurpWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use BurpWeb, :controller
      use BurpWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: BurpWeb
      import Plug.Conn
      alias BurpWeb.Router.Helpers, as: Routes
      import BurpWeb.Gettext

      alias Burp.Helpers
      alias BurpWeb.Helpers, as: WebHelpers

      import BurpWeb.Paginator
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/burp_web/templates",
        namespace: BurpWeb

      use Appsignal.Phoenix.View

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      alias BurpWeb.Router.Helpers, as: Routes
      import BurpWeb.ErrorHelpers
      import BurpWeb.Gettext

      alias Burp.Helpers
      alias BurpWeb.Helpers, as: WebHelpers

      import Phoenix.Controller,
        only: [
          get_csrf_token: 0,
          get_flash: 2,
          view_module: 1,
          action_name: 1,
          controller_module: 1
        ]

      import BurpWeb.Paginator
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import BurpWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
