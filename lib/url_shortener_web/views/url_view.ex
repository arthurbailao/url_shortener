defmodule UrlShortenerWeb.URLView do
  use UrlShortenerWeb, :view
  alias UrlShortenerWeb.URLView

  def render("list.json", %{urls: urls}) do
    %{data: render_many(urls, URLView, "url.json")}
  end

  def render("show.json", %{url: url}) do
    %{data: render_one(url, URLView, "url.json")}
  end

  def render("url.json", %{url: url}) do
    %{hash: url.hash, url: url.url}
  end
end
