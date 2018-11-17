# RandomWordService

RandomWordService is an application that will return a random word given up to 2 parameters to the `get_random_word` function.

## Usage

This is an Elixir application, so when this module is added as a dependency, the `start_link` function will be automatically be called to load up of the word lists of parts of speech.

### `get_random_word`

Use the `get_random_word` function to get a random word. The function returns an :ok tuple with the word or an :error tuple if something is awry. (e.g. the starts_with parameter is a number).

The are up to two parameters that can be used:

* `starts_with`: A string that the random word needs to start with. Only English letters are valid. Capitalization of the string does not matter.

* `part_of_speech`: A string or atom of the part of speech the word needs to be. Valid parts of speech are adjective, adverb, noun, or verb in string or verb format. 

Both parameters do not need to be used. Using only `starts_with` will return an adjective, adverb, noun, or verb starting with the specified string. Using only `part_of_speech` will return a word starting with any letter that is the specified part of speech. 

Also, `get_random_word` can be invoked without any parameters. It will randomly select a part of speech and the starting letter.

### `lists`

There is a function called `list` that will return the struct of the parts of speech word lists.

## Examples
```elixir
iex(1)> RandomWordService.get_random_word(starts_with: "r", part_of_speech: "adjective")
{:ok, "resigned"}

iex(2)> RandomWordService.get_random_word(starts_with: "r")
{:ok, "repeatedly"}

iex(3)> RandomWordService.get_random_word(part_of_speech: "adjective")
{:ok, "relevant"}

iex(4)> RandomWordService.get_random_word()
{:ok, "all-out"}

iex(5)> RandomWordService.get_random_word(starts_with: "rat", part_of_speech: "adjective")
{:ok, "rational"}

iex(6)> RandomWordService.get_random_word(starts_with: "rrr", part_of_speech: "adjective")
{:error, "starts_with rrr not found"}

iex(7)> RandomWordService.get_random_word(stars_wth: "r", part_of_speech: "adjective")
{:error, "Cannot use invalid options"}

iex(8)> RandomWordService.get_random_word(starts_with: "r", part_of_speech: :adjctiv)
{:error, "part_of_speech adjctiv not in list of parts of speech"}

iex(9)> RandomWordService.get_random_word(starts_with: 1, part_of_speech: :adjective)
{:error, "starts_with must be a string"}

iex(10)> RandomWordService.get_random_word(starts_with: "10", part_of_speech: :adjective)
{:error, "starts_with must contain only English alphabetic characters"}
```

## Installation

The package can be installed by adding `random_word_service` 
to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    { :random_word_service,
      git: "https://github.com/patrickcarver/random_word_service.git", 
      tag: "v1.0" }
  ]
end
```
