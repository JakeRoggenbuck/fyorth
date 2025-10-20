defmodule FyorthTest do
  use ExUnit.Case
  doctest Fyorth

  test "split to words" do
    assert Fyorth.words("a b") |> length == 2
  end

  test "split lines" do
    assert Fyorth.lines(": 1 2 +\n: 2 3 +") |> length == 2
  end

  test "compile line" do
    assert Fyorth.compile_line(": 1 2 +") == [{:ok, 0}, {:ok, 1}, {:ok, 1}, {:ok, 2}]
  end

  test "tokenize" do
    assert Fyorth.tokenize("+") == {:ok, 2}
    assert Fyorth.tokenize(":") == {:ok, 0}
    assert Fyorth.tokenize("1") == {:ok, 1}
    assert Fyorth.tokenize("9") == {:ok, 1}

    assert Fyorth.tokenize("ö") == {:err, -1}
  end
end
