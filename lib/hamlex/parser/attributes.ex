defmodule Hamlex.Parser.Attributes do
  use Combine

  def html_attributes do
    between(char(?(), sep_by(html_attribute, ignore(word_of(~r{[\s\n\r]}))), char(?)))
  end

  defp html_attribute do
    either equal_attribute, attribute_name
  end

  defp equal_attribute do
    pipe [attribute_name, ignore(char ?=), attribute_value], &List.to_tuple/1
  end

  defp attribute_name do
    word_of(~r{[-\w]+})
  end

  defp attribute_value do
    choice [single_quoted_string, double_quoted_string, variable_name]
  end

  defp single_quote, do: char ?'
  defp double_quote, do: char ?"

  defp single_quoted_string do
    map between(single_quote, word_of(~r{[^']}), single_quote), &{:string, &1}
  end

  defp double_quoted_string do
    map between(double_quote, word_of(~r{[^"]}), double_quote), &{:elixir, &1}
  end

  defp variable_name, do: word |> map(&{:var, &1})
end
