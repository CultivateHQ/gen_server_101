# GenServer101

`GenServer`s are main the building blocks of Elixir and Erlang applications. They are the things that hold state and "do stuff".

If you are writing a web application with Phoenix and Ecto, you may not need to write a GenServer for quite a while; however 
you will be using them under the hood and benefit from knowing what is going on.

If you are writing almost anything else in Elixir, especially a Nerves application, you will be using GenServers.

## What you'll need to fully participate

* A functioning Elixir installation. Anything > 1.4 is probably fine but I'd go for 1.7.3-otp-21
* Basic ability to follow Elixir syntax
* Some familiarity with Elixir pattern matching. https://elixir-lang.org/getting-started/pattern-matching.html

## Part 1 - Processes without GenServers

GenServers are really just a set of functionality layered over "processes", Erlang/Elixir's basic unit of
concurrency. This may be overly ambitious for an hour, but we will work on implementing a simple counter with just
processes and our brains.

The instructions for this are in the moduledoc for [lib/process_fun.ex](lib/process_fun.ex).

## Part 2 - GenServers

Ok, that was fairly easy but a bit boilerplate. GenServers does all that basic work, adds extra functionality, and
deals with the edgecases that we haven't thought of.

Here we are presented with the counter, reimplemented as a GenServer. Next we will add some functionality.





