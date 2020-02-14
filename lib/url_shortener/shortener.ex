defmodule UrlShortener.Shortener do
  @moduledoc """
  The Shortener context.
  """

  import Ecto.Query, warn: false
  alias UrlShortener.Repo

  alias UrlShortener.Shortener.URL
  alias UrlShortener.Hash.Base62

  @doc """
  Gets a single url.

  Raises `Ecto.NoResultsError` if the Url does not exist.

  ## Examples

      iex> get_url!(1)
      %URL{}

      iex> get_url!(2)
      ** (Ecto.NoResultsError)

  """
  def get_url!(id), do: Repo.get!(URL, id)

  @doc """
  Creates a url.

  ## Examples

      iex> create_url(%{field: value})
      {:ok, %URL{}}

      iex> create_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_url(attrs \\ %{}) do
    %URL{}
    |> URL.changeset(attrs)
    |> Repo.insert()
  end

  def create_urls(%{"urls" => urls}) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    bulk = Enum.map(urls, &%{url: &1, inserted_at: now, updated_at: now})

    Repo.insert_all(URL, bulk, returning: [:id, :url])
  end
end
