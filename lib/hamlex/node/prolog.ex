defmodule Hamlex.Node.Prolog do
  alias Hamlex.Node
  @derive [Node]
  @type t :: %__MODULE__{type: String.t, body: []}
  defstruct type: "", body: []

  @prologs %{
    "html4" => %{
      "" => ~S(<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">),
      "frameset" => ~S(<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">),
      "strict" => ~S(<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">),
      "XML" => "",
    },
    "html5" => %{
      "" => "<!DOCTYPE html>",
      "XML" => "",
    },
    "xhtml" => %{
      "" => ~S(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">),
      "1.1" => ~S(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">),
      "5" => "<!DOCTYPE html>",
      "basic" => ~S(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">),
      "frameset" => ~S(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">),
      "mobile" => ~S(<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">),
      "XML" => "<?xml version='1.0' encoding='utf-8' ?>",
    },
  }

  @spec to_html(t, keyword) :: Hamlex.html
  def to_html(%__MODULE__{type: type, body: []}, opts \\ []) do
    # TODO: see if we can move option processing elsewhere
    opts = Keyword.merge Hamlex.default_options, opts
    format = opts[:config][:format]

    prologs = prologs_for_format format
    case Map.fetch(prologs, type) do
      {:ok, html} -> html
      :error -> raise ArgumentError, "Don't know how to render a prolog for #{inspect type} in format #{inspect format}."
    end
  end

  defp prologs_for_format(format) do
    case Map.fetch(@prologs, format) do
      {:ok, prologs} -> prologs
      :error -> raise ArgumentError, "Don't know how to render prologs for #{inspect format}"
    end
  end
end
