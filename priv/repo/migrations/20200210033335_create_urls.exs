defmodule UrlShortener.Repo.Migrations.CreateUrls do
  use Ecto.Migration

  def change do
    create table(:urls, primary_key: false) do
      add :hash, :string, primary_key: true
      add :url, :string

      timestamps()
    end
  end
end
