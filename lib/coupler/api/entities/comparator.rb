module Coupler
  module API
    class Comparator
      def initialize(attributes)
        @attributes = attributes
      end

      def id
        @attributes[:id]
      end

      def kind
        @attributes[:kind]
      end

      def set_1
        @attributes[:set_1]
      end

      def set_2
        @attributes[:set_2]
      end

      def options
        @attributes[:options]
      end

      def to_h
        @attributes.dup
      end
    end
  end
end
