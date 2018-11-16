defmodule RandomWordService.Validators.StartsWith do
  @moduledoc """

  """

  @doc """
  
  """
  def validate(starts_with) do
    starts_with
    |> is_string()
    |> is_all_letters()
    |> lowercase()
  end



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

  defp lowercase({ :ok, starts_with }) do
    {:ok, String.downcase(starts_with) }
  end

  defp lowercase({ :error, message }) do
    { :error, message }
  end
end