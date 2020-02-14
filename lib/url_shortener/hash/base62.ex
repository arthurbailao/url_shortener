defmodule UrlShortener.Hash.Base62 do
  @moduledoc """
  Base62 encoder
  """

  @mapping 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
  @base 62

  @doc """
  Converts given integer to base62
  """
  @spec encode(integer()) :: String.t()
  def encode(num) when num < @base do
    <<Enum.at(@mapping, num)>>
  end

  def encode(num) do
    encode(div(num, @base)) <> encode(rem(num, @base))
  end

  @doc """
  Converts given base62 string to integer
  """
  @spec decode(String.t()) :: integer()
  def decode(str) do
    str
    |> to_charlist()
    |> Enum.reduce(0, fn x, acc ->
      acc * @base + Enum.find_index(@mapping, fn n -> n == x end)
    end)
  end
end
