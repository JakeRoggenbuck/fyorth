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
    line |> String.split()
  end

  @doc """
  ## Examples

      iex> Fyorth.lines(": 1 2 +\\n: 2 3 +")
      [": 1 2 +", ": 2 3 +"]

  """
  def lines(context) do
    context |> String.split("\n")
  end

  @doc """
  ## Examples

      iex> Fyorth.tokenize(":")
      0

  """
  def tokenize(word) do
    cond do
      word == "+" -> 2
      number_string?(word) -> 1
      word == ":" -> 0
      true -> :unknown
    end
  end

  @doc """
  ## Examples

      iex> Fyorth.compile_line(": 1 2 +")
      [0, 1, 1, 2]

  """
  def compile_line(line) do
    line
    |> Fyorth.words()
    |> Enum.map(&Fyorth.tokenize/1)
  end

  @doc """
  ## Examples

      iex> Fyorth.number_string?("1")
      true

      iex> Fyorth.number_string?("9")
      true

      iex> Fyorth.number_string?("a")
      false

  """
  def number_string?(word) when is_binary(word) do
    case Integer.parse(word) do
      {_, ""} -> true
      _ -> false
    end
  end
end
