module Coupler::API
  class Router
    def route(req, res)
      action = setup_action(req)
      if action
        action.call(req, res)
      else
        res.status = 404
        { "errors" => ["not found"] }
      end
    end

    def setup_action(req)
      raise NotImplementedError
    end
  end
end
