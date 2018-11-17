defmodule RandomWordService do
  @moduledoc """
  
  """

  alias RandomWordService.Validators.{StartsWith, PartOfSpeech}

  @parts_of_speech [:adjective, :adverb, :noun, :verb] 
  @name __MODULE__

  defstruct(adjective: [], adverb: [], noun: [], verb: [])

  def start_link() do
    Agent.start_link(&load_from_files/0, name: @name)
  end

  def get_random_word(starts_with: starts_with, part_of_speech: part_of_speech) do
    with { :ok, validated_starts_with } <- StartsWith.validate(starts_with),
         { :ok, validated_part_of_speech } <- PartOfSpeech.validate(part_of_speech, @parts_of_speech) 
    do
      do_random_word(validated_starts_with, validated_part_of_speech)
    else
      err -> err       
    end
  end

  def get_random_word(_) do
    { :error, "Cannot use invalid options" }
  end

  defp do_random_word(starts_with, part_of_speech) do
    word = part_of_speech
            |> get_part_of_speech_list()
            |> find_words_starting_with(starts_with)
            |> return_filter_result(starts_with)
    { :ok, word }    
  end

  def lists() do
    Agent.get(@name, fn struct -> struct end)
  end

  defp find_words_starting_with(list, starts_with) do
    Enum.filter(list, &(String.starts_with?(&1, starts_with)))
  end

  defp return_filter_result([], starts_with) do
    { :error, "starts_with #{starts_with} not found"} 
  end

  defp return_filter_result(list, _) do
    Enum.random(list)
  end

  defp get_part_of_speech_list(part_of_speech) do
    Agent.get(@name, fn struct -> Map.fetch(struct, part_of_speech) end)
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

    { file_name, list }  
  end
end
