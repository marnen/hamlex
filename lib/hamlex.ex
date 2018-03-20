defmodule Hamlex do
  alias Hamlex.Renderer
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
    Hamlex.Parser.parse(haml) |> to_html(opts)
  end

  defp to_html([lines], opts) do
    Enum.join (for line <- lines, do: to_html line, opts), "\n"
  end

  defp to_html(["!!!"|body], opts), do: Renderer.prolog(body, opts)
end
