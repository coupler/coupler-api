module CouplerAPI
  class Controller
    def not_found(req, res)
      res.status = 404
      { 'errors' => [ 'not found' ] }
    end

    def build_action(name)
      action = method(name.to_sym || :not_found)
      lambda do |req, res|
        result = action.call(req, res)
        if result.is_a?(Hash) && result.has_key?('errors') && res.status == 200
          res.status = 400
        end
        res["Content-Type"] = "application/json"
        res.write(JSON.generate(result))
      end
    end
  end
end
