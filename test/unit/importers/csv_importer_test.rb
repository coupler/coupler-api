require 'test_helper'

module Coupler
  module API
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
          data = [
            %{int,float,floatish,text,empty,junk},
            %{0,0.0,0,foo,,123},
            %{1,1.0,1,bar,,hey},
            %{2,2.0,2.0,baz,,1.0},
            %{3,3.0,3,qux,,},
            %{4,4.0,4.0,quux,,blah},
            %{,,,,,}
          ].join("\n")

          fields = @importer.detect_fields(data)

          expected = [
            { 'name' => 'int', 'kind' => 'integer' },
            { 'name' => 'float', 'kind' => 'float' },
            { 'name' => 'floatish', 'kind' => 'float' },
            { 'name' => 'text', 'kind' => 'text' },
            { 'name' => 'empty', 'kind' => 'text' },
            { 'name' => 'junk', 'kind' => 'text' }
          ]
          assert_equal(expected, fields)
        end

        def test_create_database
          f = Tempfile.new("coupler-api")
          f.puts %{int,float,floatish,text,empty,junk}
          f.puts %{0,0.0,0,foo,,123}
          f.puts %{1,1.0,1,bar,,hey}
          f.puts %{2,2.0,2.0,baz,,1.0}
          f.puts %{3,3.0,3,qux,,}
          f.puts %{4,4.0,4.0,quux,,blah}
          f.close

          fields = [
            { 'name' => 'int', 'kind' => 'integer', 'primary_key' => true },
            { 'name' => 'float', 'kind' => 'float' },
            { 'name' => 'floatish', 'kind' => 'float' },
            { 'name' => 'text', 'kind' => 'text' },
            { 'name' => 'empty', 'kind' => 'text' },
            { 'name' => 'junk', 'kind' => 'text' }
          ]

          expected = File.join(@storage_path, 'foo.db')
          database_path = @importer.create_database('foo', fields, f.path)
          assert_equal expected, database_path

          connect_args =
            if RUBY_PLATFORM == "java"
              [ "jdbc:sqlite:#{database_path}", convert_types: false ]
            else
              [ "sqlite://#{database_path}" ]
            end
          Sequel.connect(*connect_args) do |db|
            schema = db.schema(:foo)
            schema_fields = schema.collect do |f|
              field = { 'name' => f[0].to_s, 'kind' => f[1][:db_type] }
              field['primary_key'] = true if f[1][:primary_key]
              field
            end
            assert_equal fields, schema_fields

            ds = db[:foo]
            expected_rows = [
              { int: 0, float: 0.0, floatish: 0.0, text: "foo", empty: nil, junk: "123" },
              { int: 1, float: 1.0, floatish: 1.0, text: "bar", empty: nil, junk: "hey" },
              { int: 2, float: 2.0, floatish: 2.0, text: "baz", empty: nil, junk: "1.0" },
              { int: 3, float: 3.0, floatish: 3.0, text: "qux", empty: nil, junk: nil },
              { int: 4, float: 4.0, floatish: 4.0, text: "quux", empty: nil, junk: "blah" }
            ]
            assert_equal expected_rows, ds.all
          end
        end
      end
    end
  end
end
