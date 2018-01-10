defmodule ComeBikeWeb.Router do
  use ComeBikeWeb, :router

  if Mix.env() == :prod do
    use Plug.ErrorHandler
    use Sentry.Plug
  end

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Phauxth.Authenticate)
  end

  scope "/auth", ComeBikeWeb do
    pipe_through(:browser)
    get("/:provider", AuthController, :request)
    get("/:provider/callback", AuthController, :callback)
    post("/:provider/callback", AuthController, :callback)
    delete("/logout", AuthController, :delete)
  end

  scope "/", ComeBikeWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/tos", PageController, :tos)
    get("privacy", PageController, :privacy)
    resources("/rides", RideController)
    resources("/users", UserController)
    resources("/sessions", SessionController, only: [:new, :create, :delete])
  end
end
