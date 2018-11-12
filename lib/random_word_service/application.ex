defmodule RandomWordService.Application do
  use Application

  def start(_type, _args) do
    RandomWordService.start_link()
  end
end