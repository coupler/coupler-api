module Coupler::API
  class ComparatorRouter < Router
    def initialize(controller)
      @controller = controller
    end

    def self.dependencies
      ['ComparatorController']
    end

    def setup_action(req)
      path = req.path_info
      action = nil

      case req.request_method
      when 'GET'
        case path
        when '', '/'
          action = @controller.build_action(:index)
        when %r{/(\d+)$}
          req['comparator_id'] = $1.to_i
          action = @controller.build_action(:show)
        end
      when 'POST'
        case path
        when '', '/'
          action = @controller.build_action(:create)
        end
      when 'PUT'
        case path
        when %r{/(\d+)$}
          req['comparator_id'] = $1.to_i
          action = @controller.build_action(:update)
        end
      when 'DELETE'
        case path
        when %r{/(\d+)$}
          req['comparator_id'] = $1.to_i
          action = @controller.build_action(:delete)
        end
      end

      action
    end
  end
end
