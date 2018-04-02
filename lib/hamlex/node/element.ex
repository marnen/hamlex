defmodule Hamlex.Node.Element do
  alias Hamlex.{Node, Utils}
  @derive [Node]
  @type selector :: String.t
  @type attribute_name :: String.t
  @type attribute_value :: String.t | variable
  @type variable_name :: String.t
  @type variable :: {:var, variable_name}
  @type attribute :: (atomic :: attribute_name) | {name :: attribute_name, value :: attribute_value}
  @type attributes :: [attribute]
  @type selector_map :: %{id: String.t | nil, class: [String.t]}
  @type t :: %__MODULE__{
    name: String.t,
    selectors: [selector],
    attributes: attributes,
    body: [Node.t]
  }
  defstruct name: "div", selectors: [], attributes: [], body: []

  @void_elements ~w[area base br col embed hr img input link meta param source track wbr] # see https://www.w3.org/TR/html52/syntax.html#void-elements

  @spec to_html(t, keyword) :: Hamlex.html
  def to_html(%__MODULE__{} = element, opts \\ []) do
    # TODO: see if we can move option processing elsewhere
    opts = Keyword.merge Hamlex.default_options, opts
    format = opts[:config][:format]

    if self_closing?(element) do
      case format do
        "xhtml" -> self_closing_tag element, opts
        _ -> void_tag element, opts
      end
    else
      content_tag(element, opts)
    end
  end

  defp content_tag(%__MODULE__{body: body} = element, opts) do
    body_html = case body do
      [] -> nil
      [_|_] -> "\n" <> Utils.indent(Enum.map_join body, "\n", &(Node.to_html &1, opts)) <> "\n"
      _ -> body
    end
    Enum.join [opening_tag(element, opts), body_html, closing_tag(element)]
  end

  defp opening_tag(%__MODULE__{} = element, opts) do
    "<#{name_and_attributes element, opts}>"
  end

  defp closing_tag(%__MODULE__{name: name}), do: "</#{name}>"

  defp self_closing_tag(%__MODULE__{} = element, opts) do
    "<#{name_and_attributes element, opts} />"
  end

  defp void_tag(%__MODULE__{} = element, opts), do: opening_tag(element, opts)

  @spec normalize_selectors(t, keyword) :: t
  defp normalize_selectors(%__MODULE__{selectors: selectors, attributes: attributes} = element, opts) do
    import Enum, only: [empty?: 1, map: 2, sort: 1]
    import List, only: [flatten: 1]

    original_selectors = selector_map selectors

    %{class: class, id: id, other: other_attributes} = Map.merge %{class: [], id: [], other: []}, Enum.group_by(attributes, fn attribute ->
      case attribute do
        {key, _} when key in ["class", "id"] -> String.to_existing_atom key
        _ -> :other
      end
    end)

    extra_classes = flatten(for {"class", classes} <- class, do: String.split(resolve classes, opts))
    new_classes = sort map List.wrap(original_selectors[:class]) ++ extra_classes, &("." <> &1)

    extra_ids = flatten(for {"id", ids} <- id, do: String.split(ids))
    all_ids = List.wrap(original_selectors[:id]) ++ extra_ids
    new_id = if empty?(all_ids), do: [], else: ["#" <> (all_ids |> Enum.join("_"))]

    %{element | selectors: new_id ++ new_classes, attributes: other_attributes}
  end

  @spec selector_map([Hamlex.haml]) :: selector_map
  defp selector_map(selectors) do
    all_selectors = selectors |> Enum.group_by(&selector_type/1, &String.slice(&1, 1..-1))
    if all_selectors[:id] do
      Map.merge all_selectors, %{id: List.last all_selectors[:id]}
    else
      all_selectors
    end
  end

  defp selector_type("#" <> _), do: :id
  defp selector_type("." <> _), do: :class

  defp self_closing?(%__MODULE__{name: name}) do
    import String, only: [ends_with?: 2]
    name in @void_elements or name |> ends_with?("/")
  end

  defp name_and_attributes(%__MODULE__{name: name} = element, opts) do
    import Enum, only: [join: 1, join: 2, map: 2]

    name = String.replace_suffix name, "/", ""
    element = normalize_selectors(element, opts)
    %{selectors: selectors, attributes: attributes} = element
    selector_map = selector_map(selectors)
    selector_string = map(selector_map, fn {type, value} ->
      value_string = if is_list(value), do: join(value, " "), else: value
      attribute_string {type, value_string}, opts
    end) |> join
    attribute_strings = map attributes, &(attribute_string &1, opts)
    join [name, selector_string, attribute_strings]
  end

  @spec resolve(attribute_value, keyword) :: String.t
  defp resolve({:var, key}, opts), do: Map.fetch!(opts[:locals], String.to_existing_atom key)
  defp resolve(value, _opts), do: value

  @spec attribute_string(attribute, keyword) :: String.t
  defp attribute_string({name, value}, opts), do: " #{name}=#{Utils.q resolve(value, opts)}"
  defp attribute_string(name, _opts), do: " #{name}"
end
