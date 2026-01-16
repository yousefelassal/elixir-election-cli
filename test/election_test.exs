defmodule ElectionTest do
  use ExUnit.Case
  doctest Election

  test "greets the world" do
    assert Election.hello() == :world
  end
end
