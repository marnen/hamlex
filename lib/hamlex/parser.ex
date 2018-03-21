defmodule Hamlex.Parser do
  use Combine

  @sigils %{
    class: ".",
    element: "%",
    implicit_div: "%%",
    id: "#",
    prolog: "!!!"
  }

  def parse(haml), do: Combine.parse(haml, parser)

  defp parser, do: sep_by line, ignore(newline)

  defp line, do: choice [prolog, element, implicit_div]

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
    pipe [word, option(string "/")], &Enum.join/1
  end

  defp implicit_div do
    pipe [many(selector), rest], &([@sigils.implicit_div | &1])
  end

  defp selector do
    pipe [selector_sigil, word], &Enum.join/1
  end

  defp selector_sigil do
    either string(@sigils.class), string(@sigils.id)
  end

  defp rest do
    take_while(&(&1 not in '\r\n'))
  end
end
