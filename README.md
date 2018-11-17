# RandomWordService

RandomWordService is an application that will return a random word given upto 2 parameters to the `get_random_word` function.

## Usage

Use the `get_random_word` function to get a random word. The function returns an :ok tuple with the word or an :error tuple if something is awry. (e.g. the starts_with parameter is a number).

The are upto two parameters that can be used which are:

`starts_with`: A string that the random word needs to start with. Only English letters are valid. Capitalization of the string does not matter.

`part_of_speech`: A string or atom of the part of speech the word needs to be. Valid parts of speech are adjective, adverb, noun, or verb in string or verb format. 

Both parameters do not need to be used. Using only `starts_with` will return an adjective, adverb, noun, or verb starting with the specified string. Using only `part_of_speech` will return a word starting with any letter that is the specified part of speech. 

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
