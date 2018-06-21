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
        fields: convert_to_json(hsh[:fields])
      })
    end

    def unserialize(hsh)
      hsh.merge({
        fields: convert_from_json(hsh[:fields])
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
