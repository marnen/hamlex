defmodule Hamlex.Parser.Attributes do
  use Combine

  def html_attributes do
    between(char(?(), sep_by(html_attribute, ignore(whitespace)), char(?)))
  end

  defp html_attribute do
    either equal_attribute, attribute_name
  end

  defp equal_attribute do
    pipe [attribute_name, ignore(char ?=), attribute_value], &List.to_tuple/1
  end

  def ruby_attributes do
    between(begin_hash, sep_by(ruby_attribute, ignore(comma_and_space)), end_hash)
  end

  def ruby_attribute do
    pipe [ruby_key, ignore(hashrocket), attribute_value], &List.to_tuple/1
  end

  defp attribute_name do
    word_of(~r{[-\w]+})
  end

  defp ruby_key, do: either(single_quoted_string, atom)

  defp atom do
    pair_right char(?:), word
  end

  defp attribute_value do
    choice [single_quoted_value, double_quoted_value, number,  variable_name]
  end

  defp comma_and_space, do: between option(whitespace), char(?,), option(whitespace)
  defp hashrocket, do: between option(whitespace), string("=>"), option(whitespace)
  defp begin_hash, do: sequence [char(?{), option(whitespace)]
  defp end_hash, do: sequence [option(whitespace), char(?})]
  defp whitespace, do: word_of(~r{[\s\n\r]})
  defp single_quote, do: char ?'
  defp double_quote, do: char ?"

  defp single_quoted_string, do: between(single_quote, word_of(~r{[^']}), single_quote)
  defp single_quoted_value, do: map single_quoted_string, &{:string, &1}

  defp double_quoted_value do
    map between(double_quote, word_of(~r{[^"]}), double_quote), &{:elixir, &1}
  end

  defp number, do: many1(digit) |> map(&{:string, Enum.join(&1)})

  defp variable_name, do: word |> map(&{:var, &1})
end
