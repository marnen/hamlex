defmodule Hamlex.Renderers.Element do
  @defaults [format: "html5"]
  @void_elements ~w[area base br col embed hr img input link meta param source track wbr] # see https://www.w3.org/TR/html52/syntax.html#void-elements

  def to_html(name \\ "div", selectors, body, opts) do
    opts = Keyword.merge @defaults, opts
    format = opts[:format]

    if self_closing?(name) do
      case format do
        "xhtml" -> self_closing_tag name, selectors
        _ -> void_tag name, selectors
      end
    else
      opening_tag(name, selectors) <> closing_tag(name)
    end
  end

  defp opening_tag(name, selectors) do
    "<#{name_and_attributes name, selectors}>"
  end

  defp closing_tag(name), do: "</#{name}>"

  defp self_closing_tag(name, selectors) do
    "<#{name_and_attributes name, selectors} />"
  end

  defp void_tag(name, selectors) do
    "<#{name_and_attributes name, selectors}>"
  end

  @spec process_selectors([Hamlex.haml]) :: %{id: [String.t], class: [String.t]}
  defp process_selectors(selectors) do
    selectors |> Enum.group_by(&selector_type/1, &String.slice(&1, 1..-1))
  end

  defp selector_type("#" <> _), do: :id
  defp selector_type("." <> _), do: :class

  defp self_closing?(name) do
    import String, only: [ends_with?: 2]
    name in @void_elements or name |> ends_with?("/")
  end

  defp name_and_attributes(name, selectors) do
    import Enum, only: [join: 1, join: 2]

    name = String.replace_suffix name, "/", ""
    selector_string = for {type, values} <- process_selectors(selectors) do
      " #{type}='#{join values, " "}'"
    end |> join
    join [name, selector_string]
  end
end
