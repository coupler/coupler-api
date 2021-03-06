module Coupler::API
  class Injector
    class NotRegisteredError < Exception; end

    def initialize(parent = nil)
      @registry = {}
      @parent = nil
    end

    def register_service(name, service)
      @registry[name] = {type: 'service', klass: service}
    end

    def register_factory(name, factory)
      @registry[name] = {type: 'factory', factory: factory}
    end

    def register_value(name, value)
      @registry[name] = {type: 'value', object: value}
    end

    def get(name, chain = [])
      if !@registry.has_key?(name)
        if @parent
          return @parent.get(name, chain)
        end

        raise "#{name} has not been registered (chain: #{chain.inspect})"
      end

      entry = @registry[name]

      if !entry[:object]
        case entry[:type]
        when 'service'
          klass = entry[:klass]
          deps = klass.dependencies.collect { |name| get(name, chain + [name]) }
          object = klass.new(*deps)
        when 'factory'
          factory = entry[:factory]
          deps =
            if factory.respond_to?(:dependencies)
              factory.dependencies.collect { |name| get(name, chain + [name]) }
            else
              []
            end
          object = factory.call(*deps)
        end
        entry[:object] = object
      end

      entry[:object]
    end
  end
end
