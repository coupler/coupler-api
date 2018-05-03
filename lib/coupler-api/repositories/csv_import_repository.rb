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
        detected_fields: convert_to_json(hsh[:detected_fields])
      })
    end

    def unserialize(hsh)
      hsh.merge({
        detected_fields: convert_from_json(hsh[:detected_fields])
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
  end
end
