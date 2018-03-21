defmodule Hamlex.UtilsSpec do
  use ESpec
  alias Hamlex.Utils

  describe ".indent" do
    context "default" do
      it "indents each line of the string by 2 spaces" do
        expect(Utils.indent "foo\nbar").to eq "  foo\n  bar"
      end
    end

    context "indent given" do
      it "indents each line of the string by the given number of spaces" do
        expect(Utils.indent "foo\nbar", 1).to eq " foo\n bar"
      end
    end
  end
end
