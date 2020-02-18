defmodule UrlShortenerWeb.Instrumenter.Repo do
  @moduledoc """
  Instrumentation of Ecto activity.
  """
  use Prometheus.EctoInstrumenter
end
