defmodule RandomWordService do
  @moduledoc """
  
  """

  @text_dir "../text_files/"
  @parts_of_speech ["adjective", "adverb", "noun", "verb"] 
  @name __MODULE__

  defstruct(adjective: [], adverb: [], noun: [], verb: [])
  
  def get_random_word(starts_with: letter, part_of_speech: part_of_speech) do
    word = part_of_speech
           |> get_part_of_speech_list()
           |> Enum.filter(fn word -> String.starts_with?(word, letter) end)
           |> Enum.random()

    {:ok, word}
  end

 # def get_random_word(starts_with: _letter, part_of_speech: invalid_part_of_speech) do
 #   {:error, "Sorry, but #{invalid_part_of_speech} is not in parts of speech list."}
 # end

  def lists() do
    Agent.get(@name, fn struct -> struct end)
  end

  def start_link() do
    Agent.start_link(&load_from_files/0, name: @name)
  end

  defp get_part_of_speech_list(key) do
    Agent.get(@name, fn struct -> Map.fetch(struct, key) end)
    |> elem(1)
  end  

  def load_from_files() do
    @parts_of_speech
    |> Stream.map(fn name -> Task.async(fn -> load_file(name) end) end)
    |> Enum.map(&Task.await/1)
    |> convert_to_struct()
  end

  defp convert_to_struct(keyword_list) do
    map = Enum.into(keyword_list, %{})
    Map.merge(%@name{}, map)
  end

  defp load_file(file_name) do
    list = 
      @text_dir <> file_name <> ".txt"
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> Stream.map(&String.trim_trailing/1) 
      |> Enum.to_list()

    { String.to_atom(file_name), list }  
  end
end
