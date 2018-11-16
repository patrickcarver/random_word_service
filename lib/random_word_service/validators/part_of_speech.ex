defmodule RandomWordService.Validators.PartOfSpeech do
  @moduledoc """
  
  """

  @doc """
  
  """
  def validate(part_of_speech, allowed_list) do
    part_of_speech
    |> convert_to_atom_if_needed()
    |> check_if_in(allowed_list)
  end



  defp convert_to_atom_if_needed(part_of_speech) do
    case is_atom(part_of_speech) do
      true -> part_of_speech
      false -> part_of_speech |> to_string() |> String.to_atom()
    end
  end

  defp check_if_in(part_of_speech, allowed_list) do
    case part_of_speech in allowed_list do
      true -> { :ok, part_of_speech }
      false -> { :error, "part_of_speech #{part_of_speech} not in list of parts of speech" }
    end
  end
end