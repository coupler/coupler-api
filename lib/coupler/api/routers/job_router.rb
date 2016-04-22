module Coupler
  module API
    class JobRouter
      def initialize(controller)
        @controller = controller
      end

      def self.dependencies
        ['JobController']
      end

      def route(req, res)
        path = req.path_info
        action = nil
        result = nil

        case req.request_method
        when 'POST'
          case path
          when '', '/'
            action = @controller.method(:create)
          end
        when 'OPTIONS'
          result = ''
        end

        if action
          result = action.call(req, res)
        end

        if !result.nil?
          res.write(result)
          res.status = 200
        else
          res.status = 404
        end
      end
    end
  end
end
