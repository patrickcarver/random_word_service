defmodule RandomWordServiceTest do
  use ExUnit.Case
  doctest RandomWordService

  test "get a random word starting with 'a' and an adjective" do
    { :ok, word } = RandomWordService.get_random_word(starts_with: "a", part_of_speech: "adjective")
    assert String.starts_with?(word, "a")
  end
  
  test "starts_with is an integer" do
    result = RandomWordService.get_random_word(starts_with: 1, part_of_speech: "adjective")
    assert { :error, "value must be a string" } = result
  end

  test "starts_with is an empty string" do
    result = RandomWordService.get_random_word(starts_with: "", part_of_speech: "adjective") 
    assert { :error, "value must contain only English alphabetic characters" } = result   
  end

  test "part_of_speech is not valid" do
    result = RandomWordService.get_random_word(starts_with: "a", part_of_speech: "adjctiv")
    assert { :error, "value is not in the list" } = result
  end

  test "invalid keyword stars_with passed in along with valid keyword part_of_speech" do
    result = RandomWordService.get_random_word(stars_with: "a", part_of_speech: "noun")
    assert { :error, "Cannot use invalid options" } = result
  end

  test "part_of_speech can be a string in valid parts of speech" do
    result = RandomWordService.get_random_word(starts_with: "a", part_of_speech: "noun")
    assert { :ok, _ } = result
  end

  test "part_of_speech as string is not valid"  do
    result = RandomWordService.get_random_word(starts_with: "r", part_of_speech: "adjctiv")
    assert { :error, "value is not in the list" } = result      
  end

  test "starts_with is a string not found" do
    result = RandomWordService.get_random_word(starts_with: "asdf", part_of_speech: "noun")
    assert { :error, "starts_with asdf not found"} = result
  end

  test "part_of_speech is only parameter passed in" do
    assert { :ok, _ } = RandomWordService.get_random_word(part_of_speech: "adverb")
  end

  test "starts_with is only parameter passed in" do
    result = RandomWordService.get_random_word(starts_with: "g")
    assert { :ok, _ } = result
  end

  test "no parameters" do
    assert { :ok, _ } = RandomWordService.get_random_word()
  end
end
