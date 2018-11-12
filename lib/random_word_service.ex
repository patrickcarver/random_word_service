defmodule RandomWordService do
  @moduledoc """
  
  """

  @parts_of_speech ["adjective", "adverb", "noun", "verb"] 
  @name __MODULE__

  defstruct(adjective: [], adverb: [], noun: [], verb: [])

  def start_link() do
    Agent.start_link(&load_from_files/0, name: @name)
  end

  def get_random_word(starts_with: letter, part_of_speech: _) when not is_binary(letter) do
    { :error, "Cannot use a non-string in starts_with" } 
  end

  def get_random_word(starts_with: "", part_of_speech: _) do
    { :error, "Cannot use an empty string in starts_with" }
  end

  def get_random_word(starts_with: letter, part_of_speech: part_of_speech) do
    acceptable_parts_of_speech = @parts_of_speech ++ Enum.map(@parts_of_speech, &String.to_atom/1)

    case part_of_speech in acceptable_parts_of_speech do
      true ->

        word = part_of_speech
                |> atomize_part_of_speech()
                |> get_part_of_speech_list()
                |> Enum.filter(fn word -> String.starts_with?(word, letter) end)
                |> Enum.random()

        {:ok, word}
      false ->
        {:error, "Cannot find #{part_of_speech} in parts of speech list."}
    end
  end

  def get_random_word(_) do
    { :error, "Cannot use invalid options" }
  end

  def lists() do
    Agent.get(@name, fn struct -> struct end)
  end

  def atomize_part_of_speech(part_of_speech) do
    case is_binary(part_of_speech) do
      true -> String.to_atom(part_of_speech)
      false -> part_of_speech
    end
  end

  defp get_part_of_speech_list(key) do
    Agent.get(@name, fn struct -> Map.fetch(struct, key) end)
    |> elem(1)
  end  

  defp load_from_files() do
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
      "../text_files/#{file_name}.txt"
      |> Path.expand(__DIR__)
      |> File.stream!()
      |> Stream.map(&String.trim_trailing/1) 
      |> Enum.to_list()

    { String.to_atom(file_name), list }  
  end
end
