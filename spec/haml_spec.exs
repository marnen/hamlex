defmodule HamlSpec do
  use ESpec, async: true

  {:ok, json} = File.read "#{__DIR__}/haml_spec/tests.json"
  tests = Poison.Parser.parse! json

  @context_names [
    "headers",
    "basic Haml tags and CSS",
    "tags with unusual HTML characters",
    "tags with unusual CSS identifiers",
    "tags with inline content",
    "tags with nested content",
    "tags with HTML-style attributes",
    "tags with Ruby-style attributes",
    "silent comments",
  ]

  for {context_name, example_data} <- tests, context_name in @context_names do
    context context_name do
      import String, only: [to_atom: 1]
      for {name, %{"haml" => haml, "html" => html} = fields} <- example_data do
        opts = for field_name <- ["config", "locals"], into: [] do
          opt = Map.get fields, field_name, %{}
          {field_name |> to_atom, (for {key, value} <- opt, into: %{}, do: {key |> String.to_atom, value})}
        end

        specify name do
          result = Hamlex.render unquote(haml), unquote(Macro.escape opts)
          normalized_result = String.replace result, ~r/^ +/m, ""
          expect(normalized_result).to eq unquote(html)
        end
      end
    end
  end
end
