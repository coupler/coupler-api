module Coupler
  module API
    class Job
      def initialize(attributes)
        @attributes = attributes
      end

      def id
        @attributes[:id]
      end

      def kind
        @attributes[:kind]
      end

      def linkage_id
        @attributes[:linkage_id]
      end

      def to_h
        @attributes.dup
      end
    end
  end
end
