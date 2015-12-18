module Coupler
  module API
    class SequelAdapter
      def intialize(options)
        @options = options
      end

      private

      def db
        if @db.nil?
          @db = Sequel.connect(options)
        end
      end
    end
  end
end
