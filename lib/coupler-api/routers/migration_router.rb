module CouplerAPI
  class MigrationRouter < Router
    def initialize(controller)
      @controller = controller
    end

    def self.dependencies
      ['MigrationController']
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
          req['migration_id'] = $1.to_i
          action = @controller.build_action(:show)
        end
      when 'POST'
        case path
        when '', '/'
          action = @controller.build_action(:create)
        #when %r{/(\d+)/run$}
          #req['migration_id'] = $1.to_i
          #action = @controller.build_action(:run)
        end
      when 'OPTIONS'
        result = ''
      end
      action
    end
  end
end
