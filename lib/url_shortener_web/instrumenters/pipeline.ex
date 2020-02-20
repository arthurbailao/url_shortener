defmodule UrlShortenerWeb.Instrumenter.Pipeline do
  @moduledoc """
  Instrumentation for the entire plug pipeline.
  """
  use Prometheus.PlugPipelineInstrumenter
  @spec label_value(:request_path, Plug.Conn.t()) :: binary
  def label_value(:request_path, conn) do
    Regex.replace(~r/^\/[0-9a-zA-Z]+$/, conn.request_path, "/:hash")
  end
end
