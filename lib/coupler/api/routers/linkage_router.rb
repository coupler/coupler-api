module Coupler
  module API
    class LinkageRouter
      def initialize(controller)
        @controller = controller
      end

      def self.dependencies
        ['LinkageController']
      end

      def route(req, res)
        path = req.path_info
        action = nil
        result = nil

        case req.request_method
        when 'GET'
          case path
          when '', '/'
            action = @controller.method(:index)
          when %r{/(\d+)$}
            req['linkage_id'] = $1.to_i
            action = @controller.method(:show)
          end
        when 'POST'
          case path
          when '', '/'
            action = @controller.method(:create)
          end
        when 'PUT'
          case path
          when %r{/(\d+)$}
            req['linkage_id'] = $1.to_i
            action = @controller.method(:update)
          end
        #when 'DELETE'
          #case path
          #when %r{/(\d+)$}
            #req['linkage_id'] = $1.to_i
            #action = @controller.method(:delete)
          #end
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
