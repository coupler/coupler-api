module CouplerAPI
  class Runner
    def initialize(linkage_runner)
      @linkage_runner = linkage_runner
    end

    def self.dependencies
      [ 'LinkageRunner' ]
    end

    def run(job)
      runner =
        case job.kind
        when 'linkage' then @linkage_runner
        end

      if runner.nil?
        raise "couldn't find runner for job of type #{job.kind.inspect}"
      end

      runner.run(job)
    end
  end
end
