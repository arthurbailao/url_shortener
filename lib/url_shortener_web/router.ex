defmodule UrlShortenerWeb.Router do
  use UrlShortenerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UrlShortenerWeb do
    pipe_through :api

    post "/urls", URLController, :create
    get "/urls/:hash", URLController, :show
  end

  scope "/", UrlShortenerWeb do
    get "/:hash", URLController, :get_and_redirect
  end
end
