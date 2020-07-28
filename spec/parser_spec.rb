require "./parser.rb"
require_relative "helpers"


describe Parser do
    let(:parser){Parser.new("webserver.log")}

    it "parses the log and returns the most viewed pages and most uniquely viewed pages" do
        expect(STDOUT).to receive(:puts).with("/about/2 has 90 visits, /contact has 89 visits, /index has 82 visits, /about has 81 visits, /help_page/1 has 80 visits, /home has 78 visits")
        expect(STDOUT).to receive(:puts).with("/index has 23 unique page visits, /home has 23 unique page visits, /contact has 23 unique page visits, /help_page/1 has 23 unique page visits, /about/2 has 22 unique page visits, /about has 21 unique page visits")
        parser.parse()
    end

    it "converts lines to visits" do
        expect(parser.send(:convert_lines_to_visits)).to eq(Helpers.visits_nested_array)
    end

    context "when calculating most unique visits" do

        it "converts visits to unique visits" do
            allow(parser).to receive(:visits){ Helpers.visits_nested_array}
            expect(parser.send(:convert_visits_to_unique_visits)).to eq(Helpers.unique_visits_hash)
        end

        it "counts unique visits for each page" do
            allow(parser).to receive(:unique_visits){ Helpers.unique_visits_hash}
            expect(parser.send(:count_unique_visits_for_each_page)).to eq(Helpers.unique_visits_count)
        end

        it "orders unique visits for each page" do
            expect(parser.send(:order_pages_in_descending_order, Helpers.unique_visits_count)).to eq(Helpers.unique_visits_count_descending_order)
        end

        it "formats unique visits for each page" do
            expect(parser.send(:format_unique_visits_output, Helpers.unique_visits_count_descending_order)).to eq(Helpers.formatted_unique_visits_count)
        end
    end

    context "when calculating most visits" do

        it "removes ip addresses from visits" do
            allow(parser).to receive(:visits){ Helpers.visits_nested_array}
            expect(parser.send(:remove_ip_addresses_from_visits)).to eq(Helpers.visits_page_only)
        end

        it "iterates visits and increments page counts" do
            allow(parser).to receive(:visits_page_only){ Helpers.visits_page_only}
            expect(parser.send(:iterate_visits_and_increment_visit_count)).to eq(Helpers.visit_count)
        end

        it "orders pages by descending number of visits" do
            descending_order = parser.send(:order_pages_in_descending_order, Helpers.visit_count)
            expect(descending_order).to eq(Helpers.descending_order)
        end

        it "formats the output of most visits" do
            expect(parser.send(:format_most_visits_output, Helpers.descending_order)).to eq(Helpers.formatted_most_visits)
        end
    end
 end