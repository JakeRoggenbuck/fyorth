defmodule FyorthTest do
  use ExUnit.Case
  doctest Fyorth

  test "split to words" do
    assert Fyorth.words("a b") |> length == 2
  end
end
