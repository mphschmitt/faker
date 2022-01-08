# frozen_string_literal: true

module Faker
  class Xml < Base
    class << self
      def xml(length: 1, depth: 1, dtd: true)
        closing_tags = []
        xml_doc = ::String.new

        # Document Type Definition.
        xml_doc << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" if dtd

        # Root element.
        xml_doc << "<faker>\n"

        length.times do |l|
          elem_id = l + 1 # Elements are one indexed.
          current_depth = depth

          xml_doc << "  <#{elem_name}#{elem_id}>"
          current_depth -= 1 if current_depth.positive? # This element counts as depth one.

          # We want the fake content and the tags to be on the same line.
          if current_depth.zero?
            xml_doc << generate_fake_data
            closing_tags << "</#{elem_name}#{elem_id}>\n"
          else
            xml_doc << "\n"
            closing_tags << "  </#{elem_name}#{elem_id}>\n"
          end

          nested_elem_id = elem_id
          nested_indent = '    '
          current_depth.times do |d|

            nested_elem_id = "#{nested_elem_id}-1"
            xml_doc << "#{nested_indent}<#{elem_name}#{nested_elem_id}>"

            if d == current_depth - 1
              xml_doc << generate_fake_data
              closing_tags << "</#{elem_name}#{nested_elem_id}>\n"
            else
              xml_doc << "\n"
              closing_tags << "#{nested_indent}</#{elem_name}#{nested_elem_id}>\n"
            end

            nested_indent += '  '
          end

          xml_doc << closing_tags.pop until closing_tags.empty?
        end

        xml_doc << '</faker>'

        xml_doc
      end

      private

      def elem_name
        'element'
      end

      def generate_fake_data
        'Fake data'
      end

      def attr_name
        'attr'
      end

      def attr_value
        'value'
      end

      def append_attributes(elem)
        rand(3).times do |n|
          elem << " #{attr_name}#{n}=\"#{attr_value}#{n}\""
        end
      end
    end
  end
end
