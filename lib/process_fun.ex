defmodule ProcessFun do
  @moduledoc """
  Ok, let's have a bit of play from `iex` to get a feel for processes. Let's start from `iex`.

  ```
  iex -S mix
  > pid =  spawn(fn -> IO.puts("Hello matey") end)

  ```
  You'll say "Hello matey" printed out. `pid` is the Process ID.

  ```
  > Process.alive?(pid)
  false
  ```

  The process is not alive, as the function exited so the process finished.

  ```
  > pid = spawn(fn ->
    receive do
      :go_go -> IO.puts("Goodbye, sweet world!")
    end
  end)
  > Process.alive?(pid)
  true
  ```

  This process is now blocked, waiting for the message `:go_go` - it's still ALIVE! Nothing is printed out.

  ```
  send(pid, :go_go)
  ```

  The message "Goodbye, sweet world!" is now printed out.

  ```
  Process.alive?(pid)
  false
  ```

  Now we have seen processes that do a thing, then die. Useful, but maybe not that useful. Let's use the functions in this
  module to implement a counter.

  ```
  > pid = spawn(ProcessFun, :simplest_counter, [0])
  Process.alive?(pid)
  true
  ```

  "The count is 0" is output. This is a slightly different form of `spawn`, which takes 3 argements: the module, function, and arguments; it spawns
  with `simplest_counter` in this module, passing in `0`. It is blocking, waiting for an `:increment` message, and alive.

  ```
  send(pid, :increment)
  Process.alive?(pid)
  true
  ```

  Now the count is 1, and the process is still alive. The function did not exit - it called itself with the new count. WE ARE CHANGING STATE IN A
  FUNCTIONAL ENVIRONMENT!

  If a process changes state in a forest but no-one is there, has it changed state? In this case we know because we are cheating and outputing the
  count to `standard out`. Let's implement querying the output.

  ```
  pid = spawn(ProcessFun, :queryable_counter, [0])
  ```

  The `queryable_counter` is silet on standard out, so how do we know what the count is?

  ```
  send(pid, {:query, self()})
  ```

  `self()` returns the process id (pid) of the current process. In this case it is the pid of your iex session. We send it along as part
  of the message to the counter process, so it knows where to send the results of the query. You can see in the function body the line
  `send(pid, {:counter_value, value}))`. Typing `flush` displays and empties out your iex mailbox.

  ```
  > flush()
  {:counter_value, 0}
  > send(pid, :increment)
  > send(pid, {:query, self()})
  > flush()
  {:counter_value, 1}
  ```

  Now we have the basics of building intercommunicating processes; we have the barest skeleton of what is inside a GenServer. Next let's reimplement this as a more idiomatic GenServer.

  """

  @spec simplest_counter(number()) :: no_return()
  def simplest_counter(value) do
    IO.puts("The count is #{value}")

    receive do
      :increment ->
        simplest_counter(value + 1)
    end
  end

  @spec queryable_counter(number()) :: no_return()
  def queryable_counter(value) do
    receive do
      :increment ->
        queryable_counter(value + 1)

      {:query, pid} ->
        send(pid, {:counter_value, value})
        queryable_counter(value)
    end
  end
end
