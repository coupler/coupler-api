module Coupler
  module API
    class ComparatorRepository < ROM::Repository
      relations :comparators

      def self.dependencies
        ['container']
      end

      def initialize(env, options = {})
        super
        @create = env.commands[:comparators][:create]
        @update = env.commands[:comparators][:update]
        @delete = env.commands[:comparators][:delete]
      end

      def find
        comparators.to_a.collect do |obj|
          instantiate(obj)
        end
      end

      def first(conditions)
        obj = comparators.where(conditions).one
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
          Comparator.new(obj.to_h)
        end
      end
    end
  end
end
