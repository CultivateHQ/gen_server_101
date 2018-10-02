defmodule NumberGuessTest do
  use ExUnit.Case

  test "guess incrementing from 1" do
    {:ok, pid} = NumberGuess.start_link()
    do_guess({:incrementing, pid}, {1, 1})
  end

  test "guess decremeting from 100" do
    {:ok, pid} = NumberGuess.start_link()
    do_guess({:decrementing, pid}, {100, 1})
  end

  test "50 is sometimes too high, and sometimes too low" do
    results =
      for _i <- 1..1_000 do
        {:ok, pid} = NumberGuess.start_link()
        NumberGuess.guess(pid, 50)
      end

    assert Enum.member?(results, :too_high)
    assert Enum.member?(results, :too_low)
  end

  defp do_guess({direction, pid}, {guess, guess_count}) do
    assert guess_count < 101
    guess_result = NumberGuess.guess(pid, guess)
    assert NumberGuess.guesses(pid) == guess_count
    check_guess_result(guess_result, {direction, pid}, {guess, guess_count})
  end

  defp check_guess_result(:correct, _, _), do: nil

  defp check_guess_result(guess_result, {:incrementing, pid}, {guess, guess_count}) do
    assert guess_result == :too_low
    do_guess({:incrementing, pid}, {guess + 1, guess_count + 1})
  end

  defp check_guess_result(guess_result, {:decrementing, pid}, {guess, guess_count}) do
    assert guess_result == :too_high
    do_guess({:decrementing, pid}, {guess - 1, guess_count + 1})
  end
end
