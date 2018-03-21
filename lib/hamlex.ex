defmodule Hamlex do
  alias Hamlex.{Node, Tree}
  @moduledoc """
  Documentation for Hamlex.
  """

  @default_options [format: "html5"]

  @type haml :: String.t
  @type html :: String.t
  @type line :: {integer, Node.t}

  @spec default_options() :: keyword
  def default_options do
    @default_options
  end

  @doc """
  Renders a Haml string to HTML.
  """
  @spec render(haml, keyword) :: html
  def render(haml, opts \\ []) do
    [parsed] = Hamlex.Parser.parse(haml)
    Tree.from(parsed) |> Enum.map_join(&(Node.to_html &1, opts))
  end
end
