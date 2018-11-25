defmodule RandomWordService.Validators.StartsWith do
  @moduledoc """
  Checks if starts_with is a string of only English letters and makes it lowercase
  """

  @doc """
  Ensures starts_with is a string with only English letters and puts in it lower case.
  Starts_with needs to be lower case because the word list has only lower case words
  and an uppercase string will not match.
  """
  def validate(starts_with) do
    starts_with
    |> is_string()
    |> is_all_letters()
  end

  # Private functions

  defp is_string(starts_with) do
    case is_binary(starts_with) do
      true -> { :ok, starts_with }
      false -> { :error, "starts_with must be a string" }
    end    
  end

  defp is_all_letters({ :ok, starts_with }) do
    case Regex.match?(~r/^[a-zA-Z]+$/, starts_with) do
      true -> { :ok, starts_with }
      false -> { :error, "starts_with must contain only English alphabetic characters" }
    end
  end

  defp is_all_letters({ :error, message }) do
    { :error, message }
  end
end