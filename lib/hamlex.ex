defmodule Hamlex do
  alias Hamlex.Node
  @moduledoc """
  Documentation for Hamlex.
  """

  @default_options [format: "html5"]

  @type haml :: String.t
  @type html :: String.t

  @spec default_options() :: keyword
  def default_options do
    @default_options
  end

  @doc """
  Renders a Haml string to HTML.
  """
  @spec render(haml, keyword) :: html
  def render(haml, opts \\ []) do
    parsed = Hamlex.Parser.parse(haml)
    parsed |> to_html(opts)
  end

  @typep line :: {integer, Node.t}

  @spec to_html([[line]], keyword) :: html
  defp to_html([lines], opts) do
    Enum.join (for {indent, node} <- lines, do: Node.to_html node, opts), "\n"
  end

  defp to_html(["%", name, selectors, body], opts) do
    Element.to_html name, selectors, body, opts
  end

  defp to_html(["%%", selectors, body], opts) do
    Element.to_html selectors, body, opts
  end
end
