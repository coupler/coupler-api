module Coupler::API
  class ComparatorRepository < Repository
    def initialize(*args)
      super
      @name = :comparators
      @constructor = Comparator
    end

    private

    def serialize(hsh)
      hsh.merge({
        set_1: convert_to_json(hsh[:set_1]),
        set_2: convert_to_json(hsh[:set_2]),
        options: convert_to_json(hsh[:options])
      })
    end

    def unserialize(hsh)
      hsh.merge({
        set_1: convert_from_json(hsh[:set_1]),
        set_2: convert_from_json(hsh[:set_2]),
        options: convert_from_json(hsh[:options])
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
