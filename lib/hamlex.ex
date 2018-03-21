defmodule Hamlex do
  alias Hamlex.Renderers.{Element, Prolog}
  @moduledoc """
  Documentation for Hamlex.
  """

  @type haml :: String.t
  @type html :: String.t

  @doc """
  Renders a Haml string to HTML.
  """
  @spec render(haml, keyword) :: html
  def render(haml, opts \\ []) do
    parsed = Hamlex.Parser.parse(haml)
    parsed |> to_html(opts)
  end

  defp to_html([lines], opts) do
    Enum.join (for line <- lines, do: to_html line, opts), "\n"
  end

  defp to_html(["!!!" | body], opts), do: Prolog.to_html(body, opts)

  defp to_html(["%", name, selectors, body], opts) do
    Element.to_html name, selectors, body, opts
  end

  defp to_html(["%%", selectors, body], opts) do
    Element.to_html selectors, body, opts
  end
end
