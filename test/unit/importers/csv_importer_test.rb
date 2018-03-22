require 'test_helper'

module CouplerAPI
  module UnitTests
    class CSVImporterTest < Minitest::Test
      def setup
        @storage_path = Dir.mktmpdir("coupler-api")
        @importer = CSVImporter.new(@storage_path)
      end

      def teardown
        FileUtils.rm_rf(@storage_path)
      end

      def test_detect_fields_guesses_types
        f = Tempfile.new("coupler-api")
        f.puts %{int,float,floatish,text,empty,junk}
        f.puts %{0,0.0,0,foo,,123}
        f.puts %{1,1.0,1,bar,,hey}
        f.puts %{2,2.0,2.0,baz,,1.0}
        f.puts %{3,3.0,3,qux,,}
        f.puts %{4,4.0,4.0,quux,,blah}
        f.puts %{,,,,,}
        f.close

        fields = @importer.detect_fields(f.path)
        f.unlink

        expected = [
          { 'name' => 'int', 'kind' => 'integer' },
          { 'name' => 'float', 'kind' => 'float' },
          { 'name' => 'floatish', 'kind' => 'float' },
          { 'name' => 'text', 'kind' => 'string' },
          { 'name' => 'empty', 'kind' => 'string' },
          { 'name' => 'junk', 'kind' => 'string' }
        ]
        assert_equal(expected, fields)
      end
    end
  end
end
