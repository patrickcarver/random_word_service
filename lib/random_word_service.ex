defmodule RandomWordService do
  @moduledoc """
  Provides a random word given part of speech, number, tense, etc.
  """

  alias Poison

  @text_dir "../text_files/"

  def get_word(acronym) do

    load_json(@text_dir <> "verbs.json")

  end

  defp load_text(file) do
    file
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1) 
    |> Enum.to_list()
  end

  defp load_json(file) do
    file
    |> Path.expand(__DIR__)
    |> File.read!()
    |> Poison.decode!()
    |> Enum.map(&convert_string_keys_to_atoms/1)
  end

  defp convert_string_keys_to_atoms(map) do
    Enum.map(map, fn {key, value} -> {String.to_atom(key), value} end)
    |> Enum.into(%{})    
  end
end
