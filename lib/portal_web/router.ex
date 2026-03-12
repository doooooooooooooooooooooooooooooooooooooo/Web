defmodule PortalWeb.Router do
  use PortalWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, html: {PortalWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/admin", PortalWeb.Admin do
    pipe_through :browser
    resources "/contents", ContentController
  end

  scope "/", PortalWeb.Page do
    pipe_through :browser
    get "/", HomeController, :index
    get "/articles/:slug", ArticleController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", PortalWeb do
  #   pipe_through :api
  # end
end
