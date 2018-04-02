defmodule Hamlex.Node.SilentCommentSpec do
  use ESpec
  import Hamlex.Node.SilentComment
  alias Hamlex.Node.SilentComment

  describe ".to_html" do
    it "renders nothing" do
      expect(SilentComment.to_html %SilentComment{}).to eq ""
    end
  end
end
