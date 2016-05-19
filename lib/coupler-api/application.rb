module CouplerAPI
  class Application
    def initialize(routes)
      @routes = routes
    end

    def call(env)
      req = Rack::Request.new(env)
      res = Rack::Response.new()
      path = req.path_info

      router = nil
      @routes.each do |route|
        md = route[:path].match(path)
        if !md.nil?
          req.script_name += md[0]
          req.path_info = md.post_match
          router = route[:router]

          break
        end
      end

      if router
        begin
          router.route(req, res)
        rescue Exception => e
          p e
          p e.backtrace
          res.write(JSON.generate({ 'errors' => [e] }))
          res.status = 500
        end
      else
        res.status = 404
      end

      if res.not_found?
        res.write('{"errors":["not found"]}')
      end

      res.finish
    end
  end
end
