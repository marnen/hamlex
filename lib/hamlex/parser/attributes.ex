defmodule Hamlex.Parser.Attributes do
  use Combine

  def html_attributes do
    between(char(?(), sep_by(html_attribute, ignore(word_of(~r{[\s\n\r]+}))), char(?)))
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
    either single_quoted_string, variable_name
  end

  defp single_quoted_string do
    between char(?'), word_of(~r{[^']+}), char(?')
  end

  defp variable_name, do: word |> map(&{:var, &1})
end
