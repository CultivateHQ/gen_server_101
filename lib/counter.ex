defmodule Counter do
  use GenServer

  @moduledoc """
  Basic counter implemented as a GenServer.

  See the test in the corresponding directory. You can also play with this
  using iex. Note the similarities and differences between this and
  rolling your own as in `ProcessFun`.

  Using the GenServer module as a Struct (like a map with defined keys) is
  a usual pattern. This is probably overkill as there is only one value,
  but it's good pattern and GenServers often accrue further state as
  functionality evolves.

  EXERCISE 1

  Implement `decrement/1`. Remove the skip tag from the corresponding
  test in the test module.

  EXERCISE 2

  Implement `increment_after/2`. Remove the skip tag from the corresponding
  test in the test module.

  """

  @enforce_keys [:value]
  defstruct value: nil
  @type t :: %Counter{value: integer()}

  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value)
  end

  def init(initial_value) do
    ## second tuple value is the initial statee of the GenServer
    {:ok, %Counter{value: initial_value}}
  end

  @spec increment(pid()) :: :ok
  def increment(pid) do
    # cast is asynchronous
    GenServer.cast(pid, :increment)
  end

  @spec decrement(pid()) :: :ok
  def decrement(pid) do
    GenServer.cast(pid, :decrement)
    :ok
  end

  @spec increment_after(pid, non_neg_integer()) :: :ok
  def increment_after(pid, milliseconds) when milliseconds >= 0 do
    Process.send_after(pid, {:increment, self()}, milliseconds)
    :ok
  end

  @spec value(pid()) :: integer()
  def value(pid) do
    # Call is synchronous
    GenServer.call(pid, :query_value)
  end

  def handle_call(:query_value, _from, state = %{value: value}) do
    {:reply, value, state}
  end

  def handle_cast(:increment, state = %{value: value}) do
    {:noreply, %{state | value: value + 1}}
  end

  def handle_cast(:decrement, state = %{value: value}) do
    {:noreply, %{state | value: value - 1}}
  end

  def handle_info({:increment, from_pid}, state = %{value: value}) do
    new_value = value + 1
    send(from_pid, {:counter_incremented, {self(), new_value}})
    {:noreply, %{state | value: new_value}}
  end
end
