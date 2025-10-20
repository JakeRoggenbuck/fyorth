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
    assert Fyorth.compile_line(": 1 2 +") == [0, 1, 1, 2]
  end

  test "tokenize" do
    assert Fyorth.tokenize("+") == 2
    assert Fyorth.tokenize(":") == 0
    assert Fyorth.tokenize("1") == 1
    assert Fyorth.tokenize("9") == 1
  end
end
