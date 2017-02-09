module CouplerAPI
  class JobRepository < Repository
    def initialize(*args)
      super
      @name = :jobs
      @constructor = Job
    end
  end
end
