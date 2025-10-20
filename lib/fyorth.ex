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
    String.split(line)
  end
end
