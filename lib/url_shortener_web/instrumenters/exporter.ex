defmodule UrlShortenerWeb.Instrumenter.PlugExporter do
  @moduledoc """
  Exports Prometheus metrics
  """
  use Prometheus.PlugExporter
end
