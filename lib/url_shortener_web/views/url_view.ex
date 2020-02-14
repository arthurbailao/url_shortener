defmodule UrlShortenerWeb.URLView do
  use UrlShortenerWeb, :view
  alias UrlShortenerWeb.URLView
  alias UrlShortener.Hash.Base62

  def render("list.json", %{urls: urls}) do
    %{data: render_many(urls, URLView, "url.json")}
  end

  def render("show.json", %{url: url}) do
    %{data: render_one(url, URLView, "url.json")}
  end

  def render("url.json", %{url: url}) do
    hash = Base62.encode(url.id)

    short_url = URI.merge(UrlShortenerWeb.Endpoint.url(), hash) |> URI.to_string()

    %{hash: hash, short_url: short_url, url: url.url}
  end
end
