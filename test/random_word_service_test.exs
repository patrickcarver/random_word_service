defmodule RandomWordServiceTest do
  use ExUnit.Case
  doctest RandomWordService

  test "greets the world" do
    assert RandomWordService.hello() == :world
  end
end
