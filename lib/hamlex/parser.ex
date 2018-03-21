defmodule Hamlex.Parser do
  use Combine
  alias Hamlex.Node.{Element, Prolog}

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
     map choice([prolog, element, implicit_div]), &build_struct/1
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
      rest
    ]
  end

  defp element_name do
    pipe [word_of(~r{[-\w:]+}), option(string "/")], &Enum.join/1
  end

  defp implicit_div do
    pipe [many(selector), rest], &build_div/1
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

  defp rest do
    map take_while(&(&1 not in '\r\n')), &string_if_not_empty/1
  end

  defp build_div([selectors, body]) do
    %Element{name: "div", selectors: selectors, body: body}
  end

  defp build_struct(%{__struct__: _} = struct), do: struct
  defp build_struct(params) do
    import String, only: [trim: 1]
    %{prolog: prolog, element: element} = @sigils
    case params do
      [prolog, type] -> %Prolog{type: type |> to_string |> trim}
      [element, name, selectors, body] -> %Element{name: name, selectors: selectors, body: body}
    end
  end

  defp string_if_not_empty([]), do: []
  defp string_if_not_empty(charlist), do: String.trim to_string charlist
end
