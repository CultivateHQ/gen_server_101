defmodule NumberGuess do
  use GenServer

  @moduledoc """
  Continue to implement the bakend of a number guesser game.

  Generates a number between 1 and 100 (inclusive), then tell the calling
  process whether it is too big, too small, or just right. Keep track of the
  number of guesses.
  """

  @enforce_keys [:secret_number, :guesses]
  defstruct secret_number: nil, guesses: nil
  @type t :: %NumberGuess{secret_number: pos_integer(), guesses: non_neg_integer()}

  @spec start_link() :: {:ok, pid}
  def start_link do
    GenServer.start_link(__MODULE__, {})
  end

  def init(_) do
    secret_number = :rand.uniform(100)
    {:ok, %NumberGuess{secret_number: secret_number, guesses: 0}}
  end

  @doc """
  Make a guess.
  """
  @spec guess(pid(), integer()) :: :correct | :too_high | :too_low
  def guess(pid, guess) do
    GenServer.call(pid, {:guess, guess})
  end

  @doc """
  The number of guesses made so far.
  """
  @spec guesses(pid) :: non_neg_integer()
  def guesses(pid) do
    GenServer.call(pid, :guesses)
  end

  def handle_call({:guess, guess}, _from, state) do
    result = case state.secret_number do
      ^guess -> :correct
      secret_number when guess < secret_number -> :too_low
      _ -> :too_high
    end

    {:reply, result, %{state | guesses: state.guesses + 1}}
  end

  def handle_call(:guesses, _from, state = %{guesses: guesses}) do
    {:reply, guesses, state}
  end
end
