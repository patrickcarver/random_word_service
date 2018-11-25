defmodule RandomWordService.Validators.StartsWithTest do
  use ExUnit.Case
  doctest RandomWordService.Validators.StartsWith

  alias RandomWordService.Validators.StartsWith

  test "starts_with is a string but with numbers in it" do
    assert { :error, "starts_with must contain only English alphabetic characters" } = 
      StartsWith.validate("a1")
  end

  test "starts_with is an integer" do
    assert { :error, "starts_with must be a string" } = StartsWith.validate(1) 
  end
end