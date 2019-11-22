module Coupler::API
  class DatasetExportRouter < Router
    def initialize(controller)
      @controller = controller
    end

    def self.dependencies
      ['DatasetExportController']
    end

    def setup_action(req)
      path = req.path_info
      action = nil

      case req.request_method
      when 'GET'
        case path
        when %r{/(\d+)$}
          req['dataset_export_id'] = $1.to_i
          action = @controller.build_action(:show)
        when %r{/(\d+)/download$}
          req['id'] = $1.to_i
          action = @controller.build_action(:download)
        end
      end

      action
    end
  end
end
