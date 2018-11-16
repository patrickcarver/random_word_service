defmodule RandomWordService.Validators.PartOfSpeech do
  @moduledoc """
  
  """

  @doc """
  
  """
  def validate(part_of_speech, allowed_list) do
    part_of_speech
    |> ensure_value_is_atom()
    |> check_if_in(allowed_list)
  end



  defp ensure_value_is_atom(part_of_speech) do
    case is_atom(part_of_speech) do
      true -> part_of_speech
      false -> part_of_speech |> to_string() |> String.to_atom()
    end
  end

  defp check_if_in(part_of_speech, allowed_list) do
    case part_of_speech in allowed_list do
      true -> { :ok, part_of_speech }
      false -> { :error, "part_of_speech not in list of parts of speech" }
    end
  end
end