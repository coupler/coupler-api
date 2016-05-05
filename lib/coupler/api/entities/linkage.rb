module Coupler
  module API
    class Linkage
      def initialize(attributes)
        @attributes = attributes
      end

      def id
        @attributes[:id]
      end

      def dataset_1_id
        @attributes[:dataset_1_id]
      end

      def dataset_2_id
        @attributes[:dataset_2_id]
      end

      def to_h
        @attributes.dup
      end
    end
  end
end
