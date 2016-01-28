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
          when %r{/(\d+)$}
            req['dataset_id'] = $1.to_i
            action = @controller.method(:show)
          end
        when 'POST'
          case path
          when '', '/'
            action = @controller.method(:create)
          end
        end

        result = nil
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
