defmodule UrlShortener.Shortener.URL do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:hash, :string, []}
  @derive {Phoenix.Param, key: :hash}
  schema "urls" do
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(url, attrs) do
    url
    |> cast(attrs, [:hash, :url])
    |> validate_required([:hash, :url])
  end
end
