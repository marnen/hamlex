defmodule HamlSpec do
  use ESpec, async: true

  {:ok, json} = File.read "#{__DIR__}/haml_spec/tests.json"
  tests = Poison.Parser.parse! json

  @context_names [
    "headers",
    "basic Haml tags and CSS"
  ]

  for {context_name, example_data} <- tests, context_name in @context_names do
    context context_name do
      for {name, %{"haml" => haml, "html" => html} = fields} <- example_data do
        opts = case fields do
          %{"config" => config} -> for {key, value} <- config, do: {key |> String.to_atom, value}
          _ -> []
        end
        specify name do
          expect(Hamlex.render unquote(haml), unquote(opts)).to eq unquote(html)
        end
      end
    end
  end
end
