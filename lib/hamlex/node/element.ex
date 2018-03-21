defmodule Hamlex.Node.Element do
  @derive [Hamlex.Node]
  @type selector :: String.t
  @type t :: %__MODULE__{name: String.t, selectors: [selector], body: any}
  defstruct name: "div", selectors: [], body: nil

  @void_elements ~w[area base br col embed hr img input link meta param source track wbr] # see https://www.w3.org/TR/html52/syntax.html#void-elements

  @spec to_html(t, keyword) :: Hamlex.html
  def to_html(%__MODULE__{} = element, opts \\ []) do
    opts = Keyword.merge Hamlex.default_options, opts
    format = opts[:format]

    if self_closing?(element) do
      case format do
        "xhtml" -> self_closing_tag element
        _ -> void_tag element
      end
    else
      opening_tag(element) <> closing_tag(element)
    end
  end

  defp opening_tag(%__MODULE__{} = element) do
    "<#{name_and_attributes element}>"
  end

  defp closing_tag(%__MODULE__{name: name}), do: "</#{name}>"

  defp self_closing_tag(%__MODULE__{} = element) do
    "<#{name_and_attributes element} />"
  end

  defp void_tag(%__MODULE__{} = element) do
    "<#{name_and_attributes element}>"
  end

  @spec process_selectors([Hamlex.haml]) :: %{id: [String.t], class: [String.t]}
  defp process_selectors(selectors) do
    selectors |> Enum.group_by(&selector_type/1, &String.slice(&1, 1..-1))
  end

  defp selector_type("#" <> _), do: :id
  defp selector_type("." <> _), do: :class

  defp self_closing?(%__MODULE__{name: name}) do
    import String, only: [ends_with?: 2]
    name in @void_elements or name |> ends_with?("/")
  end

  defp name_and_attributes(%__MODULE__{name: name, selectors: selectors}) do
    import Enum, only: [join: 1, join: 2]

    name = String.replace_suffix name, "/", ""
    selector_string = for {type, values} <- process_selectors(selectors) do
      " #{type}='#{join values, " "}'"
    end |> join
    join [name, selector_string]
  end
end
