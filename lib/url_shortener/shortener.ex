defmodule UrlShortener.Shortener do
  @moduledoc """
  The Shortener context.
  """

  import Ecto.Query, warn: false
  alias UrlShortener.Repo

  alias UrlShortener.Shortener.URL

  @doc """
  Gets a single url.

  Raises `Ecto.NoResultsError` if the Url does not exist.

  ## Examples

      iex> get_url!("aBc")
      %URL{}

      iex> get_url!("dEf")
      ** (Ecto.NoResultsError)

  """
  def get_url!(hash), do: Repo.get!(URL, hash)

  @doc """
  Creates a url.

  ## Examples

      iex> create_url(%{field: value})
      {:ok, %URL{}}

      iex> create_url(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_url(attrs \\ %{}) do
    hash =
      1
      |> Counter.Counter.generate()
      |> Enum.to_list()
      |> List.first()
      |> Hash.Base62.encode()

    %URL{}
    |> Map.put(:hash, hash)
    |> URL.changeset(attrs)
    |> Repo.insert()
  end

  def create_urls(%{"urls" => urls}) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    bulk =
      urls
      |> length()
      |> Counter.Counter.generate()
      |> Enum.to_list()
      |> Enum.map(&Hash.Base62.encode/1)
      |> Enum.map(&%{hash: &1})
      |> Enum.zip(urls)
      |> Enum.map(fn {hash, url} ->
        Map.merge(hash, %{url: url, inserted_at: now, updated_at: now})
      end)

    Repo.insert_all(URL, bulk, returning: [:hash, :url])
  end
end
