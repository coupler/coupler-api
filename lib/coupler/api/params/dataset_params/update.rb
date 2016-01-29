module Coupler
  module API
    module DatasetParams
      class Update < Base
        def initialize(data)
          super

          @id = data['id']
        end

        def valid?
          super

          if @id.nil?
            @errors.push("id must be present")
          elsif !@id.is_a?(Fixnum)
            @errors.push("id must be a number")
          end

          @errors.empty?
        end

        def to_hash
          super.merge({ :id => @id })
        end
      end
    end
  end
end
