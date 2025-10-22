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

#### 3. Pipe Operator

```elixir
def compile_line(line) do
  line
  |> Fyorth.words()
  |> Enum.map(&Fyorth.tokenize/1)
end
```

This is a great idea. It makes sense and it's executed well.

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

#### 2. Mutability

It'll take some time to learn to write code that does not mutate state. I have a decent amount of practice using Lisp, not I haven't written anything large with Lisp.

This is obviously a good design decision for specific use cases. Elixir does not lose any points for being a functional language without mutation of course.

#### 3. Static Typing

It feels worrisome to me to not have types or type annotations. I wrote a function that can return either an integer or an atom.
```elixir
def tokenize(word) do
  cond do
    word == "+" -> 2
    number_string?(word) -> 1
    word == ":" -> 0
    true -> :unknown
  end
end
```

I know this is the case for dynamically typed languages I often use, but it feels weird in a language like elixir that tries to reduce the amount of bugs you can write by adding restrictions on your expressiveness (e.g. by enforcing immutability). Even in Python, you can add type annotations. TypeScript was also made to add types and some amount enforcement to the language.

I'll likely change this function to return either an int or an atom. I may also change it to return a hashmap with `:err` or `:ok` and then the value. I do like how this can be done.

I went back and changed it to use the ok and err hashmap.

```elixir
def tokenize(word) do
  cond do
    word == "+" -> {:ok, 2}
    number_string?(word) -> {:ok, 1}
    word == ":" -> {:ok, 0}
    true -> {:err, -1}
  end
end
```

This is better, but I have to be the one to enforce checking that it's the `:ok` variant. I would like the compiler to enforce this rule. I would also like it to enforce the return type too.

It seems like you can add `@spec` but the docs read "Elixir is still a dynamic language. That means all information about a type will be ignored by the compiler, but could be used by other tools" [[1](https://elixirschool.com/en/lessons/advanced/typespec)]. Similar to how Python works.

Here is the example:

```elixir
@spec sum_product(integer) :: integer
def sum_product(a) do
  [1, 2, 3]
  |> Enum.map(fn el -> el * a end)
  |> Enum.sum()
end
```

I just ran into a bug where the data type of a function was wrong. Here is the code that I was dealing with.

```elixir
@doc """
## Examples

    iex> Fyorth.compile_program(": 1 2 +\\n: 2 3 +")
    ["mov rax, 1\\nadd rax, 2\\n", "mov rax, 2\\nadd rax, 3\\n"]

"""
def compile_program(content) do
    content
    |> Fyorth.lines()
    |> Enum.map(&Fyorth.compile_line/1)
end
```

I was getting an error that it got a string but wanted something else. I was confused because compile_line takes in one parameter, and it's `line`. That's surely a string right? Well, I had made the mistake of calling an array of tokens `line` and since I did not have type information, I forgot what it was supposed to be. I renamed the function from `compile_line` to `compile_line_token_array`, but now I am just adding type information in the function name, instead of where it should go, which would be a type annotation of type declaration.

I changed the code to reflect this info and added something to make each line into a token first.

```elixir
@doc """
## Examples

    iex> Fyorth.compile_program(": 1 2 +\\n: 2 3 +")
    ["mov rax, 1\\nadd rax, 2\\n", "mov rax, 2\\nadd rax, 3\\n"]

"""
def compile_program(content) do
  content
  |> Fyorth.lines()
  |> Enum.map(&Fyorth.tokenize_line/1)
  |> Enum.map(&Fyorth.compile_line_token_array/1)
end
```

I also called `line`, `token_array` in the function I was calling.

```elixir
def compile_line_token_array(token_array) do
  cond do
    token_array |> Fyorth.correct_line?() -> Fyorth.code_gen_line(token_array)
    true -> "wrong!"
  end
end
```

Here is a place I would want type annotations and it would make sure I have less bugs.

### Other Observations

I'm noticing that I am having a hard time writing complicated functions. I'm fine with functions in something like Rust or Python, where they might have 10 or 20 lines. But I'm finding it very hard to do something similar in elixir because I do not like nested code, and to make something more complex, you need to next it, instead of having it procedural. This makes me naturally separate logic into its own function instead of nesting more than twice or three times. I guess here I should try the pipe operator more?

## Name Origin

I called it "Forth" with an added letter "y" to get "Fyorth". Perhaps I will retroactively make a reason for why I added a "y" to the name.
