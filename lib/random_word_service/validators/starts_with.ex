defmodule RandomWordService.Validators.StartsWith do
  def validate(starts_with) do
    with {:ok, true } <- is_string(starts_with),
         {:ok, true } <- is_all_letters(starts_with)
    do
      {:ok, String.downcase(starts_with) }
    else
      err -> err
    end 
  end  

  defp is_string(starts_with) do
    case is_binary(starts_with) do
      true -> { :ok, true }
      false -> { :error, "starts_with must be a string" }
    end
  end

  defp is_all_letters(starts_with) do
    case Regex.match?(~r/^[a-zA-Z]+$/, starts_with) do
      true -> { :ok, true }
      false -> { :error, "starts_with must contain only English alphabetic characters" }
    end
  end
end