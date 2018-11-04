defmodule RandomWordService.Dictionary do
  @moduledoc """
  
  """

  alias RandomWordService.ListLoader

  @text_dir "../../text_files/"
  @parts_of_speech [:adjective, :adverb, :noun, :verb] 
  @name __MODULE__

  defstruct(adjectives: [], adverbs: [], nouns: [], verbs: [])
  
  def start_link() do
    Agent.start_link(fn -> %@name{} end, name: @name)
  end

  def load_from_files() do
    do_load_from_files(["adjectives", "adverbs", "nouns", "verbs"])
  end

  def init() do
    {:ok, pid} = start_link()
    load_from_files()

    {:ok, pid}
  end

  def get_random_word(part_of_speech) do
    word = part_of_speech
           |> pluralize()
           |> get_part_of_speech_list()
           |> Enum.random()

    {:ok, word}
  end

  def get_random_word(invalid_part_of_speech) do
    {:error, "Sorry, but #{invalid_part_of_speech} is not in parts of speech list."}
  end

  def lists() do
    Agent.get(@name, fn struct -> struct end)
  end

  defp get_part_of_speech_list(key) do
    {:ok, list} = Agent.get(@name, fn struct -> Map.fetch(struct, key)  end)
    list
  end  

  defp pluralize(part_of_speech) do
    Atom.to_string(part_of_speech) <> "s" |> String.to_atom()  
  end  

  defp do_load_from_files(file_names) do
    file_names
    |> Stream.map(fn name -> Task.async(fn -> load_file(name) end) end)
    |> Enum.map(&Task.await/1)
  end

  defp load_file(file_name) when file_name == "verbs" do
    do_load_file(file_name, "json")
  end

  defp load_file(file_name) do
    do_load_file(file_name, "txt")
  end

  defp do_load_file(file_name, extension) do
    %{path: @text_dir, name: file_name, extension: extension}
    |> ListLoader.load_from_file()
    |> add_to_list_by_key(file_name)    
  end

  defp add_to_list_by_key(list, key) do
    Agent.update(@name, fn struct -> Map.put(struct, String.to_atom(key), list) end)
  end  
end