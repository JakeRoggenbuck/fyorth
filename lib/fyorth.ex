defmodule Fyorth do
  @moduledoc """
  Documentation for `Fyorth`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Fyorth.words("a b")
      ["a", "b"]

  """
  def words(line) do
    line |> String.split
  end

  @doc """
  ## Examples

      iex> Fyorth.lines(": 1 2 +\\n: 2 3 +")
      [": 1 2 +", ": 2 3 +"]

  """
  def lines(context) do
    context |> String.split("\n")
  end
end
