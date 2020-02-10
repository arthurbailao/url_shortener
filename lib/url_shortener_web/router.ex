defmodule UrlShortenerWeb.Router do
  use UrlShortenerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UrlShortenerWeb do
    pipe_through :api

    resources "/urls", URLController, only: [:create, :show]
  end

  scope "/", UrlShortenerWeb do
    get "/:id", URLController, :get_and_redirect
  end
end
