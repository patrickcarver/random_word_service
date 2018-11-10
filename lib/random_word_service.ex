defmodule RandomWordService do
  @moduledoc """
  
  """

  @text_dir "../text_files/"
  @parts_of_speech ["adjective", "adverb", "noun", "verb"] 
  @name __MODULE__

  defstruct(adjective: [], adverb: [], noun: [], verb: [])
  
  def init() do
    {:ok, pid} = start_link()
    load_from_files()

    {:ok, pid}
  end

  def get_random_word(starts_with: letter, part_of_speech: part_of_speech) 
    when part_of_speech in @parts_of_speech do
    word = part_of_speech
           |> get_part_of_speech_list()
           |> Enum.filter(fn word -> String.starts_with?(word, letter) end)
           |> Enum.random()

    {:ok, word}
  end

  def get_random_word(starts_with: _letter, part_of_speech: invalid_part_of_speech) do
    {:error, "Sorry, but #{invalid_part_of_speech} is not in parts of speech list."}
  end

  def lists() do
    Agent.get(@name, fn struct -> struct end)
  end



  defp start_link() do
    Agent.start_link(fn -> %@name{} end, name: @name)
  end

  defp get_part_of_speech_list(key) do
    {:ok, list} = Agent.get(@name, fn struct -> Map.fetch(struct, key)  end)
    list
  end  

  defp load_from_files() do
    @parts_of_speech
    |> Stream.map(fn name -> Task.async(fn -> load_file(name) end) end)
    |> Enum.map(&Task.await/1)
  end

  defp load_file(file_name) do
    @text_dir <> file_name <> ".txt"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1) 
    |> Enum.to_list()
    |> add_to_list_by_key(file_name)   
  end

  defp add_to_list_by_key(list, key) do
    Agent.update(@name, fn struct -> Map.put(struct, key, list) end)
  end  
end
