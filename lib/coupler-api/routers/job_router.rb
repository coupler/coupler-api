module CouplerAPI
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
      when 'GET'
        case path
        #when '', '/'
          #action = @controller.method(:index)
        when %r{/(\d+)$}
          req['job_id'] = $1.to_i
          action = @controller.method(:show)
        end
      when 'POST'
        case path
        when '', '/'
          action = @controller.method(:create)
        when %r{/(\d+)/linkage$}
          req['job_id'] = $1.to_i
          action = @controller.method(:linkage)
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
        p req.request_method
        p path
        res.status = 404
      end
    end
  end
end
