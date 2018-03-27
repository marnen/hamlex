defmodule Hamlex.Parser.Attributes do
  use Combine

  def html_attributes do
    between(char(?(), sep_by(html_attribute, ignore(word_of(~r{[\s\n\r]+}))), char(?)))
  end

  defp html_attribute do
    either equal_attribute, attribute_name
  end

  defp equal_attribute do
    pipe [attribute_name, ignore(char ?=), quoted_string], &List.to_tuple/1
  end

  defp attribute_name do
    word_of(~r{[-\w]+})
  end

  defp quoted_string do
    between char(?'), word_of(~r{[^']+}), char(?')
  end
end
