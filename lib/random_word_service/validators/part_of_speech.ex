defmodule RandomWordService.Validators.PartOfSpeech do
  @moduledoc """
  Checks if the parts_of_speech parameter is an atom  
  and in the supplied list of allowed parts of speech.
  """

  @doc """
  Ensures part of speech is an atom and checks if it is in the list of allowed parts of speech. 
  """
  def validate(part_of_speech, allowed_list) do
    part_of_speech
    |> convert_to_atom_if_needed()
    |> check_if_in(allowed_list)
  end

  # Private functions

  # We are converting to an atom because we are assuming the allowed list
  # is made up of atoms. Would handling if list had strings be worthwhile?
  defp convert_to_atom_if_needed(part_of_speech) do
    case is_atom(part_of_speech) do
      true -> part_of_speech
      # using existing_atom instead of to_atom to thwart DoS threat
      # see: https://til.hashrocket.com/posts/gkwwfy9xvw-converting-strings-to-atoms-safely
      false -> part_of_speech |> to_string() |> String.to_existing_atom()
    end
  end

  defp check_if_in(part_of_speech, allowed_list) do
    case part_of_speech in allowed_list do
      true -> { :ok, part_of_speech }
      false -> { :error, "part_of_speech #{part_of_speech} not in list of parts of speech" }
    end
  end
end