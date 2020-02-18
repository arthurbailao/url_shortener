defmodule UrlShortenerWeb.Instrumenter.Phoenix do
  @moduledoc """
  Provides instrumentation for Phoenix specific metrics.
  """
  use Prometheus.PhoenixInstrumenter
end
