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
      {:ok, 0, ":"}

  """
  def tokenize(word) do
    cond do
      word == "+" -> {:ok, 2, word}
      number_string?(word) -> {:ok, 1, word}
      word == ":" -> {:ok, 0, word}
      true -> {:err, -1, word}
    end
  end

  @doc """
  ## Examples

      iex> Fyorth.tokenize_line(": 1 2 +")
      [{:ok, 0, ":"}, {:ok, 1, "1"}, {:ok, 1, "2"}, {:ok, 2, "+"}]

  """
  def tokenize_line(line) do
    line
    |> Fyorth.words()
    |> Enum.map(&Fyorth.tokenize/1)
  end

  def correct_line(line) do
    Enum.all?(line, fn
      {:ok, _, _} -> true
      {:err, _, _} -> false
    end)
  end

  @doc """
  ## Examples

      iex> Fyorth.code_gen_line([{:ok, 0, ":"}, {:ok, 1, "1"}, {:ok, 1, "2"}, {:ok, 2, "+"}])
      "mov rax, 1\\nadd rax, 2\\n"

      iex> Fyorth.code_gen_line([{:ok, 0, ":"}, {:ok, 1, "8"}, {:ok, 1, "4"}, {:ok, 2, "-"}])
      "mov rax, 8\\nsub rax, 4\\n"

  """
  def code_gen_line(line) do
    case line do
      [{:ok, 0, _}, {:ok, 1, a}, {:ok, 1, b}, {:ok, 2, "+"}] ->
        "mov rax, " <> a <> "\nadd rax, " <> b <> "\n"

      [{:ok, 0, _}, {:ok, 1, a}, {:ok, 1, b}, {:ok, 2, "-"}] ->
        "mov rax, " <> a <> "\nsub rax, " <> b <> "\n"

      _ ->
        "-"
    end
  end

  @doc """
  ## Examples

      iex> Fyorth.compile_line([{:ok, 0, ":"}, {:ok, 1, "1"}, {:ok, 1, "2"}, {:ok, 2, "+"}])
      "mov rax, 1\\nadd rax, 2\\n"

  """
  def compile_line(line) do
    cond do
      line |> Fyorth.correct_line() -> Fyorth.code_gen_line(line)
      true -> "wrong!"
    end
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
