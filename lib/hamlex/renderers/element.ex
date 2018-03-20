defmodule Hamlex.Renderers.Element do
  def to_html(name \\ "div", selectors, body, opts) do
    self_closing = opts[:self_closing]
    if self_closing do
      self_closing_tag name, selectors
    else
      opening_tag(name, selectors) <> closing_tag(name)
    end
  end

  defp closing_tag(name), do: "</#{name}>"

  defp opening_tag(name, selectors) do
    "<#{name_and_attributes name, selectors}>"
  end

  @spec process_selectors([Hamlex.haml]) :: %{id: [String.t], class: [String.t]}
  defp process_selectors(selectors) do
    selectors |> Enum.group_by(&selector_type/1, &String.slice(&1, 1..-1))
  end

  defp selector_type("#" <> _), do: :id
  defp selector_type("." <> _), do: :class

  defp self_closing_tag(name, selectors) do
    "<#{name_and_attributes name, selectors} />"
  end

  defp name_and_attributes(name, selectors) do
    import Enum, only: [join: 1, join: 2]

    selector_string = for {type, values} <- process_selectors(selectors) do
      " #{type}='#{join values, " "}'"
    end |> join
    join [name, selector_string]
  end
end
