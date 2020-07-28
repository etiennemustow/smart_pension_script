
class Parser 
    attr_reader :lines, :visits, :visits_page_only, :visit_count, :most_visits, :unique_visits, :most_unique_visits, :unique_visit_count

    def initialize(log)
        @lines = File.readlines log
        @visits = []
        @visits_page_only = []
        @visit_count = Hash.new(0)
        @unique_visit_count = Hash.new(0)
        @unique_visits = Hash.new {|hash, key| hash[key] = []}
        @most_visits = ""
        @most_unique_visits = ""
    end


    def parse
        process_most_visits
        process_most_unique_visits
        puts most_visits
        puts most_unique_visits
    end

    private
    
    def process_most_visits
        convert_lines_to_visits
        remove_ip_addresses_from_visits
        iterate_visits_and_increment_visit_count
        descending_order_visits = order_pages_in_descending_order(visit_count)
        format_most_visits_output(descending_order_visits)
    end

    def process_most_unique_visits
        convert_lines_to_visits
        convert_visits_to_unique_visits
        count_unique_visits_for_each_page
        descending_order_unique_visits = order_pages_in_descending_order(unique_visit_count)
        format_unique_visits_output(descending_order_unique_visits)
    end
    
    
    def format_unique_visits_output(visits)
        visits.each { |page, count|
            most_unique_visits << "#{page} has #{count} unique page visits, "
        }
        most_unique_visits.delete_suffix!(", ")
    end

    def format_most_visits_output(visits)
        visits.each { |page, count|
            most_visits << "#{page} has #{count} visits, "
        }
        most_visits.delete_suffix!(", ")
    end

    def order_pages_in_descending_order(visit_count)
        visit_count.sort_by { |page, count|
              count
          }.reverse
      end

    def count_unique_visits_for_each_page
        unique_visits.each { |page, ip_addresses|
            unique_visit_count[page] = ip_addresses.length
        }

        return unique_visit_count
    end

    def convert_visits_to_unique_visits
        visits.each { |visit|
            unique_visits[visit[0]] << visit[1] 
        }

        unique_visits.each { |page, ip_addresses|
            ip_addresses.uniq!
        }

        return unique_visits
    end

    def convert_lines_to_visits
        lines.each_with_index do |line, idx|
            visit = line.split(" ") 
            visits << visit
         end
        return visits
    end

    def remove_ip_addresses_from_visits
        visits.each do |visit|
            visits_page_only << visit[0]
        end
        return visits_page_only
    end

    def iterate_visits_and_increment_visit_count
        visits_page_only.each do |page| 
            visit_count[page] += 1
        end
        return visit_count
    end

end

if ARGV.length > 0
    parser = Parser.new(ARGV[0])
    parser.parse()
end