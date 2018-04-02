defmodule Hamlex.Node.SilentComment do
  @derive [Hamlex.Node]
  @type t :: %__MODULE__{body: Hamlex.Tree.t}

  defstruct body: []

  @spec to_html(t, keyword) :: String.t
  def to_html(%__MODULE__{}, _opts \\ []), do: ""
end
