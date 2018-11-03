defmodule RandomWordService.ListLoader do
  @moduledoc """
  
  """

  alias Poison

  def load_from_file(%{file_name: name, extension: "json" } = file_info) do
    file_info.name <> "." <> file_info.extension
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1) 
    |> Enum.to_list()    
  end

  def load_from_file(%{file_name: name, extension: "txt"} = file_info) do
    file_info.name <> "." <> file_info.extension
    |> Path.expand(__DIR__)
    |> File.read!()
    |> Poison.decode!()
    |> Enum.map(&convert_string_keys_to_atoms/1)
  end

  @doc """
  Since the keys from the loaded json file are strings,
  we convert them to atoms for cleaner querying
  """
  defp convert_string_keys_to_atoms(map) do
    Enum.map(map, fn {key, value} -> {String.to_atom(key), value} end)
    |> Enum.into(%{})    
  end  
end