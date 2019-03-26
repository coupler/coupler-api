module Coupler::API
  class CsvImportRouter < Router
    def initialize(controller)
      @controller = controller
    end

    def self.dependencies
      ['CsvImportController']
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
          req['id'] = $1.to_i
          action = @controller.build_action(:show)
        when %r{/(\d+)/download$}
          req['id'] = $1.to_i
          action = @controller.build_action(:download)
        end
      when 'POST'
        case path
        when '', '/'
          action = @controller.build_action(:create)
        end
      when 'PUT'
        case path
        when %r{/(\d+)$}
          req['id'] = $1.to_i
          action = @controller.build_action(:update)
        end
      end
      action
    end
  end
end
