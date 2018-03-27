defmodule Hamlex.Tree do
  @type t :: [[Hamlex.Node.t]]
  @spec from([Hamlex.line]) :: t
  def from([]), do: []
  def from([({starting_indent, _node} = head) | tail]) do
    import Enum, only: [split_while: 2]
    {children, rest} = tail |> split_while(fn {indent, _} -> indent > starting_indent end)
    first_subtree = nest [head | children]
    [first_subtree | from(rest)]
  end

  @spec nest([Hamlex.line]) :: t
  defp nest([{_, node}]), do: node
  defp nest([{_, %{} = node} | children]) do
    %{node | body: from(children)}
  end
end
