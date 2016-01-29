module Coupler
  module API
    module DatasetParams
      class Show
        attr_reader :errors

        def initialize(data)
          if !data.is_a?(Hash)
            raise ArgumentError, "expected argument to be a Hash"
          end

          @id = data['id']

          @errors = []
        end

        def valid?
          @errors.clear

          if @id.nil?
            @errors.push("id must be present")
          elsif !@id.is_a?(Fixnum)
            @errors.push("id must be a number")
          end

          @errors.empty?
        end

        def to_hash
          {
            :id => @id
          }
        end
      end
    end
  end
end
