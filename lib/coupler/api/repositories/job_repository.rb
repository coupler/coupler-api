module Coupler
  module API
    class JobRepository < ROM::Repository
      relations :jobs

      def self.dependencies
        ['container']
      end

      def initialize(env, options = {})
        super
        @create = env.commands[:jobs][:create]
        @update = env.commands[:jobs][:update]
        @delete = env.commands[:jobs][:delete]
      end

      def find
        jobs.to_a.collect do |obj|
          instantiate(obj)
        end
      end

      def first(conditions)
        obj = jobs.where(conditions).one
        instantiate(obj)
      end

      def create(data)
        obj = @create.call([data]).one
        instantiate(obj)
      end

      def update(id, data)
        @update.by_id(id).call(data).length
      end

      def delete(id)
        @delete.by_id(id).call.length
      end

      private

      def instantiate(obj)
        if obj.nil?
          nil
        else
          Job.new(obj.to_h)
        end
      end
    end
  end
end
