defmodule HamlSpec do
  use ESpec, async: true

  {:ok, json} = File.read "#{__DIR__}/haml_spec/tests.json"
  tests = Poison.Parser.parse! json

  @context_names [
    "headers",
    "basic Haml tags and CSS",
    "tags with unusual HTML characters",
    "tags with unusual CSS identifiers",
  ]

  for {context_name, example_data} <- tests, context_name in @context_names do
    context context_name do
      for {name, %{"haml" => haml, "html" => html} = fields} <- example_data do
        opts = case fields do
          %{"config" => config} -> for {key, value} <- config, do: {key |> String.to_atom, value}
          _ -> []
        end
        specify name do
          result = Hamlex.render unquote(haml), unquote(opts)
          normalized_result = String.replace result, ~r/^ +/m, ""
          expect(normalized_result).to eq unquote(html)
        end
      end
    end
  end
end
