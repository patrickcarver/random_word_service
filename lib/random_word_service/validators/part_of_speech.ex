defmodule RandomWordService.Validators.PartOfSpeech do
  @moduledoc """
  Checks if the parts_of_speech parameter is in the supplied list 
  of allowed parts of speech.
  """

  @doc """
  Ensures part of speech is in the list of allowed parts of speech. 
  """
  def validate(part_of_speech, allowed_list) do
    case part_of_speech in allowed_list do
      true -> { :ok, part_of_speech }
      false -> { :error, "part_of_speech #{part_of_speech} not in list of parts of speech" }
    end
  end
end