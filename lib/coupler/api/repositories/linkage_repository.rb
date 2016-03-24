module Coupler
  module API
    class LinkageRepository < ROM::Repository
      relations :linkages

      def self.dependencies
        ['container']
      end

      def initialize(env, options = {})
        super
        @create = env.commands[:linkages][:create]
        @update = env.commands[:linkages][:update]
        @delete = env.commands[:linkages][:delete]
      end

      def find
        linkages.to_a.collect do |obj|
          instantiate(obj)
        end
      end

      def first(conditions)
        obj = linkages.where(conditions).one
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
          Linkage.new(obj.to_h)
        end
      end
    end
  end
end
