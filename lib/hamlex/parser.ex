defmodule Hamlex.Parser do
  use Combine
  alias Hamlex.Node.{Element, Prolog}
  alias Hamlex.Parser.Attributes

  @sigils %{
    class: ".",
    element: "%",
    id: "#",
    prolog: "!!!"
  }

  def parse(haml), do: Combine.parse(haml, parser)

  defp parser, do: sep_by line, ignore(newline)

  defp line, do: pipe [indent, expression], &List.to_tuple/1

  defp expression do
     map choice([prolog, element, implicit_div, text]), &build_struct/1
  end

  defp indent do
    map many(space), &length/1
  end

  defp prolog do
    sequence [string(@sigils.prolog), rest]
  end

  defp element do
    sequence [
      string(@sigils.element),
      element_name,
      many(selector),
      option(attributes),
      rest
    ]
  end

  defp element_name do
    pipe [word_of(~r{[-\w:]+}), option(string "/")], &Enum.join/1
  end

  defp implicit_div do
    pipe [many1(selector), option(attributes), rest], &build_div/1
  end

  defp selector do
    pipe [selector_sigil, css_identifier], &Enum.join/1
  end

  defp selector_sigil do
    either string(@sigils.class), string(@sigils.id)
  end

  defp css_identifier do
    word_of ~r{[-\w]+}
  end

  defp attributes do
    either Attributes.html_attributes, Attributes.ruby_attributes
  end

  defp text do
    map take_while(&(&1 not in '\r\n')), &string_if_not_empty/1
  end

  defp rest do
    option pair_right(spaces, text)
  end

  defp build_div(params), do: build_struct ["%", "div" | params]

  defp build_struct(%{__struct__: _} = struct), do: struct
  defp build_struct(params) do
    import String, only: [trim: 1]
    %{prolog: prolog, element: element} = @sigils
    case params do
      [prolog, type] -> %Prolog{type: type |> to_string |> trim}
      [element, name, selectors, attributes, body] ->
        %Element{name: name, selectors: selectors, attributes: List.wrap(attributes), body: body}
      string when is_binary(string) -> string
    end
  end

  defp string_if_not_empty([]), do: []
  defp string_if_not_empty(charlist), do: String.trim to_string charlist
end
