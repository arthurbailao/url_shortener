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
    url
    |> Map.from_struct()
    |> Map.take([:url])
    |> Map.merge(%{hash: Base62.encode(url.id)})
  end
end
