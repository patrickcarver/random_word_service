defmodule RandomWordService do
  @moduledoc """
  Provides a random word given part of speech, number, tense, etc.
  """

  alias Poison

  def get_word(acronym) do
    load_json("../text_files/verbs.json")

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
  end
end
