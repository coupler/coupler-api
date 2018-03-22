module CouplerAPI
  class CSVImporter
    class MalformedCSVError < Exception; end

    def initialize(storage_path)
      @storage_path = storage_path
    end

    def self.dependencies
      [ 'storage_path' ]
    end

    def detect_fields(csv_filename)
      csv = CSV.open(csv_filename)

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
            else "string"
            end

          if field['kind'].nil?
            field['kind'] = kind
          elsif field['kind'] != kind
            if (field['kind'] == "integer" && kind == "float") ||
               (field['kind'] == "float" && kind == "integer")
              field['kind'] = "float"
            else
              field['kind'] = "string"
            end
          end
        end
      end

      fields.each_value { |v| v['kind'] ||= 'string' }
      fields.values
    end
  end
end
