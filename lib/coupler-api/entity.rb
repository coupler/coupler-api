module CouplerAPI
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
  end

  def self.Entity(attribute_names, &block)
    klass = Class.new(Entity) do
      @attribute_names = attribute_names

      attribute_names.each do |attribute_name|
        define_method(attribute_name) do
          @attributes[attribute_name]
        end

        define_method("#{attribute_name}=") do |value|
          @attributes[attribute_name] = value
        end
      end
    end

    if block
      klass.module_eval(&block)
    end

    klass
  end
end
