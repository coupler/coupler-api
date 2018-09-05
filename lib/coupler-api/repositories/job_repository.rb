module CouplerAPI
  class JobRepository < Repository
    def initialize(*args)
      super
      @name = :jobs
      @constructor = Job
    end

    private

    def serialize(hsh)
      hsh.merge({
        started_at: convert_from_time(hsh[:started_at]),
        ended_at: convert_from_time(hsh[:ended_at])
      })
    end

    def unserialize(hsh)
      hsh.merge({
        started_at: convert_to_time(hsh[:started_at]),
        ended_at: convert_to_time(hsh[:ended_at])
      })
    end

    def convert_from_time(value)
      case value
      when Time
        value.iso8601
      else
        value
      end
    end

    def convert_to_time(value)
      case value
      when String
        Time.iso8601(value)
      else
        value
      end
    end
  end
end
