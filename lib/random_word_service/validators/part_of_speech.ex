defmodule RandomWordService.Validators.PartOfSpeech do
  @moduledoc """
  Checks if the parts_of_speech parameter is an atom  
  and in the supplied list of allowed parts of speech.
  """

  @doc """
  Ensures part of speech is in the list of allowed parts of speech. 
  This checks the atom version and string version of the allowed_list.
  """
  def validate(part_of_speech, allowed_list) do
    new_allowed_list = get_allowed_list_with_strings(allowed_list)
    check_if_in(part_of_speech, new_allowed_list)
  end

  # Private functions

  # allowed_list is [:adjective, :adverb, :noun, :verb], we need to get
  # the string version so that we can check when part_of_speech is a string
  # The down side of this is that the conversion is done every single time
  # this function is called.
  defp get_allowed_list_with_strings(allowed_list) do
    string_allowed_list = Enum.map(allowed_list, &to_string/1)
    allowed_list ++ string_allowed_list
  end

  defp check_if_in(part_of_speech, allowed_list) do
    case part_of_speech in allowed_list do
      true -> { :ok, part_of_speech |> ensure_value_is_atom() }
      false -> { :error, "part_of_speech #{part_of_speech} not in list of parts of speech" }
    end
  end

  # We need to make sure the part_of_speech is an atom so that it matches 
  # with the struct key. 
  defp ensure_value_is_atom(value) do
    case is_atom(value) do
      true -> value
      # using existing_atom instead of to_atom to thwart DoS threat
      # see: https://til.hashrocket.com/posts/gkwwfy9xvw-converting-strings-to-atoms-safely
      false -> String.to_existing_atom(value)
    end
  end
end