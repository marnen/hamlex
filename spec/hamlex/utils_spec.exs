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

  describe ".q" do
    it "surrounds the given string with single quotes" do
      expect(Utils.q " a string ").to eq "' a string '"
    end
  end

  describe ".qq" do
    it "surrounds the given string with double quotes" do
      expect(Utils.qq " a string ").to eq ~S(" a string ")
    end
  end
end
