defmodule UrlShortenerWeb.URLController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.Shortener
  alias UrlShortener.Shortener.URL

  action_fallback UrlShortenerWeb.FallbackController

  def create(conn, url_params = %{"url" => value}) when is_binary(value) do
    with {:ok, %URL{} = url} <- Shortener.create_url(url_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.url_path(conn, :show, url))
      |> render("show.json", url: url)
    end
  end

  def create(conn, url_params = %{"urls" => values}) when is_list(values) do
    with {_len, urls} <- Shortener.create_urls(url_params) do
      conn
      |> put_status(:created)
      |> render("list.json", urls: urls)
    end
  end

  def show(conn, %{"id" => hash}) do
    url = Shortener.get_url!(hash)
    render(conn, "show.json", url: url)
  end

  def get_and_redirect(conn, %{"id" => hash}) do
    url =
      hash
      |> Shortener.get_url!()
      |> Map.get(:url)

    redirect(conn, external: url)
  end
end
