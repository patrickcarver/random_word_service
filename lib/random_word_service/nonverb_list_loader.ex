defmodule RandomWordService.NonverbListLoader do
  @moduledoc """
  Loads words from a file line by line
  """
  
  def load_from_file(file_name) do
    file_name
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1) 
    |> Enum.to_list()    
  end
end