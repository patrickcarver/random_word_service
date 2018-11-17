defmodule RandomWordService do
  @moduledoc """
  Service that provides a random word based on what string it starts with 
  and what part of speech it is.
  """

  alias RandomWordService.Validators.{StartsWith, PartOfSpeech}

  @parts_of_speech [:adjective, :adverb, :noun, :verb] 
  @name __MODULE__

  defstruct(adjective: [], adverb: [], noun: [], verb: [])

  @doc """
  
  """
  def start_link() do
    Agent.start_link(&load_from_files/0, name: @name)
  end

  @doc """
  Function that gets a random word startig
  """
  def get_random_word(starts_with: starts_with, part_of_speech: part_of_speech) do
    with { :ok, validated_starts_with } <- StartsWith.validate(starts_with),
         { :ok, validated_part_of_speech } <- PartOfSpeech.validate(part_of_speech, @parts_of_speech) 
    do
      do_random_word(validated_starts_with, validated_part_of_speech)
    else
      err -> err       
    end
  end

  @doc """
  Function that will 
  """
  def get_random_word(starts_with: starts_with) do
    with { :ok, validated_starts_with } <- StartsWith.validate(starts_with) do
      get_random_starts_with(validated_starts_with)
    else
      err -> err     
    end
  end

  @doc """
  
  """
  def get_random_word(part_of_speech: part_of_speech) do
    with { :ok, validated_part_of_speech } <- PartOfSpeech.validate(part_of_speech, @parts_of_speech) do
      get_random_part_of_speech(validated_part_of_speech)
    else
      err -> err
    end
  end

  @doc """
  Function to be a catch-all of invalid keyword list
  """
  def get_random_word(_) do
    { :error, "Cannot use invalid options" }
  end

  @doc """
  Function to output word list struct.
  """
  def lists() do
    Agent.get(@name, fn struct -> struct end)
  end



  defp do_random_word(starts_with, part_of_speech) do
    { starts_with, part_of_speech }
    |> get_part_of_speech_list()
    |> find_words_starting_with()
    |> pick_random_word()
  end

  defp get_part_of_speech_list({ starts_with, part_of_speech }) do
    { :ok, list } = Agent.get(@name, fn struct -> Map.fetch(struct, part_of_speech) end)
    { starts_with, part_of_speech, list }
  end  

  defp find_words_starting_with({ starts_with, part_of_speech, list }) do
    filtered_list = Enum.filter(list, &(String.starts_with?(&1, starts_with)))
    { starts_with, part_of_speech, filtered_list }
  end

  defp pick_random_word({ starts_with, _, []}) do
    { :error, "starts_with #{starts_with} not found"} 
  end

  defp pick_random_word({ _, _, list }) do
    word = Enum.random(list)
    { :ok, word }
  end

  defp get_random_starts_with(starts_with) do
    part_of_speech = Enum.random(@parts_of_speech)
    do_random_word(starts_with, part_of_speech)    
  end

  defp get_random_part_of_speech(part_of_speech) do
    starts_with = get_random_letter()
    do_random_word(starts_with, part_of_speech)
  end

  defp get_random_letter() do
    ?a..?z 
    |> Enum.map(fn letter -> <<letter :: utf8>> end) # change from integers to strings
    |> Enum.random()
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
