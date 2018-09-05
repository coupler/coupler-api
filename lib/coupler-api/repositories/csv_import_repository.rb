module CouplerAPI
  class CsvImportRepository < Repository
    def initialize(*args)
      super
      @name = :csv_imports
      @constructor = CsvImport
    end

    private

    def serialize(hsh)
      hsh.merge({
        fields: convert_to_json(hsh[:fields]),
        created_at: convert_from_time(hsh[:created_at])
      })
    end

    def unserialize(hsh)
      hsh.merge({
        fields: convert_from_json(hsh[:fields]),
        created_at: convert_to_time(hsh[:created_at])
      })
    end

    def convert_to_json(value)
      if value
        JSON.generate(value)
      end
    end

    def convert_from_json(value)
      if value
        JSON.parse(value)
      end
    end

    def convert_from_time(value)
      case value
      when Time
        value.iso8601
      else
        value
      end
    end

    def convert_to_time(value)
      case value
      when String
        Time.iso8601(value)
      else
        value
      end
    end
  end
end
