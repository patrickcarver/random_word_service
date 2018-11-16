defmodule RandomWordService do
  @moduledoc """
  
  """

  @parts_of_speech [:adjective, :adverb, :noun, :verb] 
  @name __MODULE__

  defstruct(adjective: [], adverb: [], noun: [], verb: [])

  def start_link() do
    Agent.start_link(&load_from_files/0, name: @name)
  end

  defp validate_starts_with(starts_with) do
    # sanitize starts_with
      # is sw a string?
        # if so pass through
          # does sw only contain English alphabetic characters?
            # if so pass through
               # set to lower case
            # else throw error "must contain English alphabetic characters"
        # else throw error "must be a string"
    case is_binary(starts_with) do
      true ->
        case Regex.match?(~r/^[a-zA-Z]+$/, starts_with) do
          true -> { :ok, String.downcase(starts_with) }
          false -> { :error, "starts_with must contain English alphabetic characters"}
        end
      false -> 
        { :error, "starts_with must be a string" }
    end
  end

  defp validate_part_of_speech(part_of_speech) do
    { :ok, part_of_speech }
  end

  def get_random_word(starts_with: starts_with, part_of_speech: part_of_speech) do

    with {:ok, validated_starts_with} <- validate_starts_with(starts_with),
         {:ok, validated_part_of_speech} <- validate_part_of_speech(part_of_speech) 
    do
      do_random_word(validated_starts_with, validated_part_of_speech)
    else
      err -> err       
    end
   

    # sanitize part_of_speech
      # is pos an atom?
        # if so pass through
        # else is pos a string?
          # if so convert to atom
          # else is pos in @parts_of_speech?
            # if so pass throw
            # else throw error "not in parts_of_speech?"
  end

  def get_random_word(_) do
    { :error, "Cannot use invalid options" }
  end

  defp do_random_word(starts_with, part_of_speech) do
    word = part_of_speech
            |> get_part_of_speech_list()
            |> Enum.filter(&(String.starts_with?(&1, starts_with)))
            |> Enum.random()
    { :ok, word }    
  end

  def lists() do
    Agent.get(@name, fn struct -> struct end)
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
