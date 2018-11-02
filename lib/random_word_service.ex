defmodule RandomWordService do
  @moduledoc """
  Provides a random word given part of speech, number, tense, etc.
  """
  @text_dir "../text_files/"
  @name __MODULE__

  def start_link do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  def load_from_files(file_names) do
    
  end

  def get_word(acronym) do



  end




end
