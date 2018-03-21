defmodule Hamlex.TreeSpec do
  use ESpec
  alias Hamlex.Node.Element
  alias Hamlex.Tree

  describe ".from" do
    context "one line" do
      it "returns the content of the one line" do
        line = {0, %Element{}}
        expect(Tree.from [line]).to eq [%Element{}]
      end
    end

    context "multiple lines with same indent" do
      it "returns the nodes in order" do
        indent = :rand.uniform(10)
        nodes = for n <- 1..3, do: %Element{selectors: ["#line-#{n}"]}
        lines = for node <- nodes, do: {indent, node}
        expect(Tree.from lines).to eq nodes
      end
    end

    context "increasing indent" do
      it "nests the inner line in the outer one" do
        lines = [
          {0, %Element{name: "outer-1"}},
          {2, %Element{name: "inner-1"}},
          {0, %Element{name: "outer-2"}},
          {2, %Element{name: "inner-2"}}
        ]
        expect(Tree.from lines).to eq [
          %Element{name: "outer-1", body: [
            %Element{name: "inner-1"}
          ]},
          %Element{name: "outer-2", body: [
            %Element{name: "inner-2"}
          ]}
        ]
      end

      it "nests to arbitrary depth" do
        lines = for n <- 1..4, do: {n, %Element{name: "level-#{n}"}}
        expect(Tree.from lines).to eq [
          %Element{name: "level-1", body: [
            %Element{name: "level-2", body: [
              %Element{name: "level-3", body: [
                %Element{name: "level-4"}
              ]}
            ]}
          ]}
        ]
      end
    end
  end
end
