module Coupler::API
  class Controller
    def not_found(req, res)
      res.status = 404
      { 'errors' => [ 'not found' ] }
    end

    def build_action(name)
      action = method(name.to_sym || :not_found)
      lambda do |req, res|
        result = action.call(req, res)
        if result.is_a?(Hash)
          if result.has_key?('errors')
            if res.status == 200
              res.status = 400
            end
          elsif result.has_key?('_download')
            # Download file instead of handling result as json
            #
            # NOTE: this is a naive implementation, since it reads the entire
            # file into memory at once
            params = result['_download']
            res["Content-Type"] = params['content_type']
            res["Content-Disposition"] = "attachment; filename=" +
              params['filename'].inspect
            res.write(File.read(params['path']))
            return
          end
        end
        res["Content-Type"] = "application/json"
        res.write(JSON.generate(result))
      end
    end
  end
end
