module CouplerAPI
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
        when %r{/(\d+)$}
          req['dataset_id'] = $1.to_i
          action = @controller.build_action(:show)
        end
      when 'POST'
        case path
        when '', '/'
          action = @controller.build_action(:create)
        end
      end
      action
    end
  end
end
