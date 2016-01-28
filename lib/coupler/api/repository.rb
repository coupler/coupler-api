module Coupler
  module API
    class Repository
      def initialize(adapter)
        @adapter = adapter
      end

      def self.dependencies
        ['adapter']
      end

      def find
        @adapter.find(@name)
      end

      def first(conditions)
        @adapter.first(@name, conditions)
      end

      def create(data)
        @adapter.create(@name, data)
      end

      def delete(conditions)
        @adapter.delete(@name, conditions)
      end
    end
  end
end
