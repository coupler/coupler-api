module Coupler::API
  class Entity
    def self.attribute_names
      @attribute_names
    end

    def initialize(attributes = {})
      @attributes = attributes.select do |k, v|
        self.class.attribute_names.include?(k)
      end
    end

    def update(hsh)
      @attributes.update(hsh)
    end

    def to_h
      @attributes.dup
    end

    def to_sanitized_hash
      @attributes.dup
    end

    def attributes
      @attributes.dup
    end
  end
end
