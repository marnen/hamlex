defprotocol Hamlex.Node do
  alias Hamlex.Node.{Element, Prolog}
  @type t :: Element.t | Prolog.t

  def to_html(node, opts \\ [])
end

defimpl Hamlex.Node, for: Any do
  @spec to_html(Hamlex.Node.t) :: Hamlex.html
  def to_html(%{__struct__: module} = node, opts \\ []), do: module.to_html(node, opts)
end
