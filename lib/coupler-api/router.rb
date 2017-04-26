module CouplerAPI
  class Router
    def route(req, res)
      action = setup_action(req)
      if action
        action.call(req, res)
      end
    end

    def setup_action(req)
      raise NotImplementedError
    end
  end
end
