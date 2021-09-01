defmodule NudgeWeb.Router do
  use NudgeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :with_current_user do
    plug NudgeWeb.Plug.GetCurrentUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NudgeWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/login", SessionController, :login
    post "/login", SessionController, :create_session
    get "/signup", SessionController, :signup
    post "/signup", SessionController, :create_user
  end

  scope "/", NudgeWeb do
    pipe_through [:browser, :with_current_user]
    resources "/sites", SiteController, only: [:new, :show, :create, :index]
    post "/site-toggle/:id", SiteController, :toggle
    get "/logout", SessionController, :logout
    get "/welcome", PageController, :welcome
  end

  # Other scopes may use custom stacks.
  # scope "/api", NudgeWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: NudgeWeb.Telemetry
    end
  end
end
