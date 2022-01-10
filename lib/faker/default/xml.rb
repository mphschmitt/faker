# frozen_string_literal: true

module Faker
  class Xml < Base
    class << self
      def xml(length: 1, depth: 1, dtd: true, comment: false)
        closing_tags_stack = []
        xml_doc = ::String.new

        # Document Type Definition.
        xml_doc << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" if dtd

        # Root element.
        xml_doc << "<faker>\n"

        # Calculate the position of the comment if any, and insert it if necessary.
        comment_length_pos = -1
        comment_depth_pos = -1
        if comment
          comment_length_pos = rand(0..length) if length.positive?
          comment_depth_pos = rand(0..depth) if depth.positive?
          xml_doc << "  #{fake_comment}\n" if length.zero? && depth.zero?
        end

        length.times do |l|
          elem_id = l + 1 # Ids of the elements start at one.
          nested_elems_to_insert = depth

          # Insert comment and opening tag.
          xml_doc << "  #{fake_comment}\n" if l == comment_length_pos && comment_depth_pos == nested_elems_to_insert
          xml_doc << "  <#{elem_name}#{elem_id}>"
          nested_elems_to_insert -= 1 if nested_elems_to_insert.positive?

          # If no more elements need to be added, then generate fake data and add the closing tag on the same line as the opening one.
          # However, if nested elements still need to be inserted, then the closing tag must be on a new line.
          if nested_elems_to_insert.zero?
            xml_doc << generate_fake_data
            closing_tags_stack << "</#{elem_name}#{elem_id}>\n"
          else
            xml_doc << "\n"
            closing_tags_stack << "  </#{elem_name}#{elem_id}>\n"
          end

          # Insert nested elements.
          nested_elem_id = elem_id
          nested_indent = '    '
          nested_elems_to_insert.times do |d|
            # Insert comment and opening tag.
            xml_doc << "#{nested_indent}#{fake_comment}\n" if l == comment_length_pos && d == comment_depth_pos
            nested_elem_id = "#{nested_elem_id}-1"
            xml_doc << "#{nested_indent}<#{elem_name}#{nested_elem_id}>"

            # If the maximum depth passed as an argument has been reached, the we introduce fake data in the element.
            if d == nested_elems_to_insert - 1
              # Max depth comments are inserted into the tag.
              xml_doc << fake_comment if l == comment_length_pos && comment_depth_pos == d + 1
              xml_doc << generate_fake_data
              closing_tags_stack << "</#{elem_name}#{nested_elem_id}>\n"
            else
              xml_doc << "\n"
              closing_tags_stack << "#{nested_indent}</#{elem_name}#{nested_elem_id}>\n"
            end

            # The indentation level needs to increase with the depth of the xml.
            nested_indent += '  '
          end

          xml_doc << closing_tags_stack.pop until closing_tags_stack.empty?
        end

        xml_doc << "  #{fake_comment}\n" if comment_length_pos == length

        xml_doc << '</faker>'

        xml_doc
      end

      private

      def fake_comment
        "<!-- #{Faker::Lorem.paragraphs(number: 1).join('')} -->"
      end

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
