defmodule HamlSpec do
  use ESpec, async: true

  {:ok, json} = File.read "#{__DIR__}/haml_spec/tests.json"
  tests = Poison.Parser.parse! json

  for {context_name, example_data} <- tests do
    context context_name do
      for {name, %{"haml" => haml, "html" => html}} <- example_data do
        specify name do
          expect(Hamlex.render unquote(haml)).to eq unquote(html)
        end
      end
    end
  end
end
