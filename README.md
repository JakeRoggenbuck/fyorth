# Fyorth

🟣 Fyorth is a programming language similar to [Forth](https://en.wikipedia.org/wiki/Forth_(programming_language)), written in [Elixir](https://elixir-lang.org).

## Learning Elixir

This is one of my first projects using Elixir and I wanted to note down what my thoughts are about the language.

### What I like

#### 1. Doc Tests

I really like the doc tests.

```elixir
@doc """
## Examples

    iex> Fyorth.lines(": 1 2 +\\n: 2 3 +")
    [": 1 2 +", ": 2 3 +"]

"""
def lines(context) do
  context |> String.split("\n")
end
```

These docs test the `lines` function, while documenting how it should be used. I appreciate these types of tests.

#### 2. Unit Testing

```elixir
defmodule FyorthTest do
  use ExUnit.Case
  doctest Fyorth

  test "split to words" do
    assert Fyorth.words("a b") |> length == 2
  end
end
```

It was great having file exist by default. It was easy to start testing. I like when languages guide you to unit testing and make it super easy.

### What I'm still getting used to

#### 1. Testing Private Functions

```elixir
defp number_string?(word) when is_binary(word) do
  case Integer.parse(word) do
    {_, ""} -> true
    _ -> false
  end
end
```

I defined this private function but I cannot test it with the doc tests and it cannot be imported in the test file to unit test. For this example, I can just make it public, but I have a hard time with a language giving you private functions or tested functions but never both. I saw examples of libraries that make the function private just for testing and other work-arounds, but I believe this is a limitation in a language.

However, I'm still learning and maybe after some research or more usage, I'll understand and come to like this decision / limitation.

## Name Origin

I called it "Forth" with an added letter "y" to get "Fyorth". Perhaps I will retroactively make a reason for why I added a "y" to the name.
