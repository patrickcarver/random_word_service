defmodule RandomWordService.ListLoader do
  @moduledoc """
  
  """

  alias Poison

  def load_from_file(%{extension: "txt" } = file_info) do
    file_info
    |> get_full_file_name()
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1) 
    |> Enum.to_list()    
  end

  def load_from_file(%{extension: "json"} = file_info) do
    file_info
    |> get_full_file_name()
    |> Path.expand(__DIR__)
    |> File.read!()
    |> Poison.decode!()
    |> Enum.map(&convert_string_keys_to_atoms/1)
  end

  defp convert_string_keys_to_atoms(map) do
    Enum.map(map, fn {key, value} -> {String.to_atom(key), value} end)
    |> Enum.into(%{})    
  end  

  defp get_full_file_name(%{path: path, name: name, extension: extension}) do
    path <> name <> "." <> extension 
  end
end