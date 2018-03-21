defmodule Hamlex.Node.ElementSpec do
  use ESpec
  import Hamlex.Node.Element
  alias Hamlex.Node.Element

  describe ".to_html" do
    context "name given" do
      it "renders a tag of the given name" do
        expect(to_html %Element{name: "foo", selectors: [".bar"]}).to eq "<foo class='bar'></foo>"
      end
    end

    context "name not given" do
      it "renders a div" do
        expect(to_html %Element{selectors: [".bar"]}).to eq "<div class='bar'></div>"
      end
    end

    context "empty tags" do
      let :all_html, do: ~w[html4 html5]
      let :formats, do: ["xhtml" | all_html]

      context "not on the list of void elements" do
        let :tag_name, do: "not-a-void-element"

        context "no slash" do
          it "renders a separate closing tag for all formats" do
            for format <- formats do
              expect(to_html %Element{name: tag_name}, format: format).to eq "<#{tag_name}></#{tag_name}>"
            end
          end
        end

        context "trailing slash" do
          context "XHTML" do
            it "renders a self-closing tag" do
              expect(to_html %Element{name: "#{tag_name}/"}, format: "xhtml").to eq "<#{tag_name} />"
            end
          end

          context "HTML 4 and 5" do
            it "renders a singleton tag" do
              for format <- all_html do
                expect(to_html %Element{name: "#{tag_name}/"}, format: format).to eq "<#{tag_name}>"
              end
            end
          end
        end
      end

      context "on the list of void elements" do
        let :void_elements, do: ~w[area base br col embed hr img input link meta param source track wbr]

        context "XHTML" do
          it "renders a self-closing tag" do
            for tag_name <- void_elements do
              expect(to_html %Element{name: tag_name}, format: "xhtml").to eq "<#{tag_name} />"
            end
          end
        end

        context "HTML 4 and 5" do
          it "renders a singleton tag" do
            for tag_name <- void_elements do
              for format <- all_html do
                expect(to_html %Element{name: tag_name}, format: format).to eq "<#{tag_name}>"
              end
            end
          end
        end
      end
    end
  end
end
