defmodule Counter.Counter do
  use GenServer

  alias UrlShortener.Repo
  alias UrlShortener.Shortener.URL

  @idx 1

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def generate(total) do
    GenServer.call(__MODULE__, {:generate, total})
  end

  @impl true
  def init(_) do
    counter = :counters.new(@idx, [])
    value = Repo.aggregate(URL, :count)
    :counters.put(counter, @idx, value)
    {:ok, counter}
  end

  @impl true
  def handle_call({:generate, total}, _from, counter) do
    start = :counters.get(counter, @idx)

    case :counters.add(counter, @idx, total) do
      :ok -> {:reply, start..(start + total - 1), counter}
      _ -> {:reply, :error, counter}
    end
  end
end
