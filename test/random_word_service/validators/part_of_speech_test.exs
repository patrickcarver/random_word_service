defmodule RandomWordService.Validators.PartOfSpeechTest do
  use ExUnit.Case
  doctest RandomWordService.Validators.PartOfSpeech

  alias RandomWordService.Validators.PartOfSpeech

  test "part_of_speech is a string that is in the allowed list" do
    assert { :ok, "verb" } = PartOfSpeech.validate("verb", ["noun", "verb"])
  end

  test "part_of_speech is a string that is not in the allowed list" do
    error = {:error, "part_of_speech thing not in list of parts of speech"}
    assert error = PartOfSpeech.validate("thing", ["noun", "verb"])
  end
end