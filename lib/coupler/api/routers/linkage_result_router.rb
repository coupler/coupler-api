module Coupler::API
  class LinkageResultRouter < Router
    def initialize(controller)
      @controller = controller
    end

    def self.dependencies
      ['LinkageResultController']
    end

    def setup_action(req)
      path = req.path_info
      action = nil

      case req.request_method
      when 'GET'
        case path
        when %r{^/(\d+)$}
          req['linkage_result_id'] = $1.to_i
          action = @controller.build_action(:show)
        when %r{^/(\d+)/matches/(\d+)$}
          req['linkage_result_id'] = $1.to_i
          req['match_index'] = $2.to_i
          action = @controller.build_action(:matches)
        end
      end
      action
    end
  end
end
