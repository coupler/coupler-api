module Coupler
  module API
    class DatasetRepository < ROM::Repository
      relations :datasets

      def self.dependencies
        ['container']
      end

      def initialize(env, options = {})
        super
        @create = env.commands[:datasets][:create]
        @update = env.commands[:datasets][:update]
        @delete = env.commands[:datasets][:delete]
      end

      def find
        datasets.to_a.collect(&:to_hash)
      end

      def first(conditions)
        datasets.where(conditions).one.to_hash
      end

      def create(data)
        @create.call([data]).one.to_hash
      end

      def update(conditions, data)
        @update.where(conditions).call(data).one.to_hash
      end

      def delete(conditions)
        @delete.where(conditions).call.one.to_hash
      end
    end
  end
end
