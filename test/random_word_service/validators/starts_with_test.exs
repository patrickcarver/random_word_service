defmodule RandomWordService.Validators.StartsWithTest do
  use ExUnit.Case
  doctest RandomWordService.Validators.StartsWith

  alias RandomWordService.Validators.StartsWith

  test "starts_with is a string but with numbers in it" do
    error = { :error, "starts_with must contain only English alphabetic characters" } 
    assert error = StartsWith.validate("a1")
  end

  test "starts_with is an integer" do
    error = { :error, "starts_with must be a string" }
    assert error = StartsWith.validate(1) 
  end

  test "starts_with is a lower case string" do
    assert {:ok, "a" } = StartsWith.validate("a")
  end

  test "starts_with is an upper case string" do
    assert {:ok, "a" } = StartsWith.validate("A")
  end
end