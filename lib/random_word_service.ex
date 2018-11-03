defmodule RandomWordService do
  @moduledoc """
  Provides a random word given part of speech, number, tense, etc.
  """

  alias RandomWordService.{NonverbListLoader, VerbListLoader}

  @text_dir "../../text_files/"
  @name __MODULE__

  defstruct(adjectives: [], adverbs: [], nouns: [], verbs: [])

  def start_link do
    Agent.start_link(fn -> %@name{} end, name: @name)
  end

  @doc """
  ["nouns", "adjectives", "adverbs", "verbs"]  
  """
  def load_from_files(file_names) do
    file_names
    |> Stream.map(fn name -> Task.async(fn -> load_file(name) end) end)
    |> Enum.map(&Task.await/1)
  end

  def lists() do
    Agent.get(@name, fn struct -> struct end)
  end

  defp load_file(file_name) when file_name == "verbs" do
    list = VerbListLoader.load_from_file(@text_dir <> file_name <> ".json")
    add_list(file_name, list)
  end

  defp load_file(file_name) do
    list = NonverbListLoader.load_from_file(@text_dir <> file_name <> ".txt")
    add_list(file_name, list)
  end

  defp add_list(key, list) do
    Agent.update(@name, fn struct -> Map.put(struct, String.to_atom(key), list) end)
  end

  def get_word(acronym) do



  end




end
