module Coupler
  module API
    class Application
      def initialize(options)
        @options = options
      end

      def call(env)
        ['200', {'Content-Type' => 'application/json'}, ['{}']]
      end
    end
  end
end
