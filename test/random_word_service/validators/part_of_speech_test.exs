defmodule RandomWordService.Validators.PartOfSpeechTest do
  use ExUnit.Case
  doctest RandomWordService.Validators.PartOfSpeech

  alias RandomWordService.Validators.PartOfSpeech

  test "part_of_speech is an atom that is in the allowed list of atoms" do
    assert { :ok, :noun } == PartOfSpeech.validate(:noun, [:noun, :adverb])
  end

  test "part_of_speech is an atom :thing that is not in allowed list of atoms" do
    error = { :error, "part_of_speech thing not in list of parts of speech" } 
    assert error == PartOfSpeech.validate(:thing, [:noun, :verb])
  end

  test "part_of_speech is a string that is in the allowed list of atoms" do
    assert { :ok, :verb } == PartOfSpeech.validate("verb", [:noun, :verb])
  end

  test "part_of_speech is a string that is not in the allowed list of atoms" do
    error = {:error, "part_of_speech thing not in list of parts of speech"}
    assert error == PartOfSpeech.validate("thing", [:noun, :verb])
  end
end