module Coupler
  module API
    class Comparator
      def initialize(attributes)
        @attributes = attributes
      end

      def id
        @attributes[:id]
      end

      def to_h
        @attributes.dup
      end
    end
  end
end
