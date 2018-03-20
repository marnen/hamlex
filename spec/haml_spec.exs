defmodule HamlSpec do
  use ESpec, async: true

  {:ok, json} = File.read "#{__DIR__}/haml_spec/tests.json"
  tests = Poison.Parser.parse! json

  @context_names [
    "headers"
  ]

  for {context_name, example_data} <- tests, context_name in @context_names do
    context context_name do
      for {name, %{"haml" => haml, "html" => html, "config" => config}} <- example_data do
        opts = for {key, value} <- config, do: {key |> String.to_atom, value}
        specify name do
          expect(Hamlex.render unquote(haml), unquote(opts)).to eq unquote(html)
        end
      end
    end
  end
end
