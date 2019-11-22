module Coupler::API
  class Application
    def initialize(dataset_router, linkage_router, comparator_router,
                   job_router, linkage_result_router, csv_import_router,
                   migration_router, dataset_export_router)
      @routes = [
        { path: %r{^/datasets(?=/)?}, router: dataset_router },
        { path: %r{^/linkages(?=/)?}, router: linkage_router },
        { path: %r{^/comparators(?=/)?}, router: comparator_router },
        { path: %r{^/jobs(?=/)?}, router: job_router },
        { path: %r{^/linkage_results(?=/)?}, router: linkage_result_router },
        { path: %r{^/csv_imports(?=/)?}, router: csv_import_router },
        { path: %r{^/migrations(?=/)?}, router: migration_router },
        { path: %r{^/dataset_exports(?=/)?}, router: dataset_export_router },
      ]
    end

    def self.dependencies
      [
        'DatasetRouter', 'LinkageRouter', 'ComparatorRouter', 'JobRouter',
        'LinkageResultRouter', 'CsvImportRouter', 'MigrationRouter',
        'DatasetExportRouter'
      ]
    end

    def call(env)
      req = Rack::Request.new(env)
      res = Rack::Response.new()
      path = req.path_info

      if req.request_method == "OPTIONS"
        res.status = 200
        res.finish
        return
      end

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
          res["Content-Type"] = "application/json"
          res.write(JSON.generate({ 'errors' => [e] }))
          res.status = 500
        end
      else
        res["Content-Type"] = "application/json"
        res.write(JSON.generate({ 'errors' => [ 'not found' ] }))
        res.status = 404
      end

      res.finish
    end
  end
end
