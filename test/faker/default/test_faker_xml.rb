# frozen_string_literal: true

require_relative '../../test_helper'

class TestFakerXml < Test::Unit::TestCase
  def setup
    @tester = Faker::Xml
  end

  def test_empty_xml
    xml = <<~EMPTY_XML.strip
      <?xml version="1.0" encoding="UTF-8"?>
      <faker>
      </faker>
    EMPTY_XML

    assert @tester.xml(length: 0, depth: 0).eql?(xml)
  end

  def test_empty_xml_without_dtd
    xml = <<~EMPTY_XML.strip
      <faker>
      </faker>
    EMPTY_XML

    assert @tester.xml(length: 0, depth: 0, dtd: false).eql?(xml)
  end

  def test_length_one_depth_one_without_dtd
    xml = <<~EMPTY_XML.strip
      <faker>
        <element1>Fake data</element1>
      </faker>
    EMPTY_XML

    assert @tester.xml(length: 1, depth: 1, dtd: false).eql?(xml)
  end

  def test_length_four_depth_one_without_dtd
    xml = <<~EMPTY_XML.strip
      <faker>
        <element1>Fake data</element1>
        <element2>Fake data</element2>
        <element3>Fake data</element3>
        <element4>Fake data</element4>
      </faker>
    EMPTY_XML

    assert @tester.xml(length: 4, depth: 1, dtd: false).eql?(xml)
  end

  def test_length_one_depth_four_xml_without_dtd
    xml = <<~EMPTY_XML.strip
      <faker>
        <element1>
          <element1-1>
            <element1-1-1>
              <element1-1-1-1>Fake data</element1-1-1-1>
            </element1-1-1>
          </element1-1>
        </element1>
      </faker>
    EMPTY_XML

    assert @tester.xml(length: 1, depth: 4, dtd: false).eql?(xml)
  end

  def test_length_two_depth_two_without_dtd
    xml = <<~EMPTY_XML.strip
      <faker>
        <element1>
          <element1-1>Fake data</element1-1>
        </element1>
        <element2>
          <element2-1>Fake data</element2-1>
        </element2>
      </faker>
    EMPTY_XML

    assert @tester.xml(length: 2, depth: 2, dtd: false).eql?(xml)
  end

  def test_length_four_depth_four_without_dtd
    xml = <<~EMPTY_XML.strip
      <faker>
        <element1>
          <element1-1>
            <element1-1-1>
              <element1-1-1-1>Fake data</element1-1-1-1>
            </element1-1-1>
          </element1-1>
        </element1>
        <element2>
          <element2-1>
            <element2-1-1>
              <element2-1-1-1>Fake data</element2-1-1-1>
            </element2-1-1>
          </element2-1>
        </element2>
        <element3>
          <element3-1>
            <element3-1-1>
              <element3-1-1-1>Fake data</element3-1-1-1>
            </element3-1-1>
          </element3-1>
        </element3>
        <element4>
          <element4-1>
            <element4-1-1>
              <element4-1-1-1>Fake data</element4-1-1-1>
            </element4-1-1>
          </element4-1>
        </element4>
      </faker>
    EMPTY_XML

    assert @tester.xml(length: 4, depth: 4, dtd: false).eql?(xml)
  end
end
