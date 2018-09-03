module CouplerAPI
  class MigrationRepository < Repository
    def initialize(*args)
      super
      @name = :migrations
      @constructor = Migration
    end

    private

    def serialize(hsh)
      hsh.merge({
        operations: convert_to_json(hsh[:operations])
      })
    end

    def unserialize(hsh)
      hsh.merge({
        operations: convert_from_json(hsh[:operations])
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
