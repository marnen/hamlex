defmodule Hamlex.Parser do
  use Combine

  @sigils %{prolog: "!!!"}

  def parse(haml), do: Combine.parse(haml, parser)

  defp parser, do: sep_by line, ignore(newline)

  defp line, do: prolog

  defp prolog do
    sequence [string(@sigils.prolog), rest]
  end

  defp rest do
    take_while(&(&1 not in '\r\n'))
  end
end
