module CouplerAPI
  class CSVImporter
    class MalformedCSVError < Exception; end

    def initialize(storage_path)
      @storage_path = storage_path
    end

    def self.dependencies
      [ 'storage_path' ]
    end

    def detect_fields(data)
      csv = CSV.new(data)

      begin
        headers = csv.shift
      rescue CSV::MalformedCSVError => e
        raise MalformedCSVError, e.message
      end

      fields = {}
      headers.each do |hdr|
        fields[hdr] = { 'name' => hdr, 'kind' => nil }
      end
      50.times do |i|
        break if csv.eof?

        begin
          row = csv.shift
        rescue CSV::MalformedCSVError => e
          raise MalformedCSVError, e.message
        end

        if row.length != headers.length
          raise MalformedCSVError, "expected row #{i} to have #{headers.length} columns, but it had #{row.length} columns"
        end

        headers.each_with_index do |hdr, j|
          next if row[j].nil?

          field = fields[hdr]
          kind =
            case row[j]
            when /^\d+$/      then "integer"
            when /^\d*\.\d+$/ then "float"
            else "text"
            end

          if field['kind'].nil?
            field['kind'] = kind
          elsif field['kind'] != kind
            if (field['kind'] == "integer" && kind == "float") ||
               (field['kind'] == "float" && kind == "integer")
              field['kind'] = "float"
            else
              field['kind'] = "text"
            end
          end
        end
      end

      fields.each_value { |v| v['kind'] ||= 'text' }
      fields.values
    end

    def create_database(name, fields, csv_filename)
      database_path = File.join(@storage_path, name + '.db')
      connect_args =
        if RUBY_PLATFORM == "java"
          [ "jdbc:sqlite:#{database_path}", convert_types: false ]
        else
          [ "sqlite://#{database_path}" ]
        end

      Sequel.connect(*connect_args) do |db|
        table_name = name.to_sym
        db.create_table(table_name) do
          fields.each do |field|
            args = [
              field['name'].to_sym,
              field['kind'].to_sym,
              { primary_key: field['primary_key'] == true }
            ]
            column(*args)
          end
        end
        ds = db[table_name]

        begin
          csv = CSV.open(csv_filename, headers: true)
          while !csv.eof?
            rows = []
            50.times do
              break if csv.eof?
              rows << csv.shift.to_h
            end
            ds.multi_insert(rows)
          end
        end
      end
      database_path
    end
  end
end
