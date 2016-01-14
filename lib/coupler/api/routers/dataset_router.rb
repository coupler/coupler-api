module Coupler
  module API
    class DatasetRouter
      def initialize(controller)
        @controller = controller
      end

      def self.dependencies
        ['DatasetController']
      end

      def route(req, res)
        path = req.path_info
        action = nil

        case req.request_method
        when 'GET'
          case path
          when '', '/'
            action = @controller.method(:index)
          end
        when 'POST'
          case path
          when '', '/'
            action = @controller.method(:create)
          end
        end

        if action
          result = action.call(req, res)
          res.write(result)
          res.status = 200
        else
          req.status = 404
        end
      end
    end
  end
end
