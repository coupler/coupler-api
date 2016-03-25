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

      def find(conditions = nil)
        rel = conditions ? comparators.where(conditions) : comparators
        rel.to_a.collect do |obj|
          instantiate(obj)
        end
      end

      def first(conditions)
        obj = comparators.where(conditions).one
        instantiate(obj)
      end

      def create(data)
        obj = @create.call([serialize(data)]).one
        instantiate(obj)
      end

      def update(id, data)
        @update.by_id(id).call(serialize(data)).length
      end

      def delete(id)
        @delete.by_id(id).call.length
      end

      private

      def instantiate(obj)
        if obj.nil?
          nil
        else
          Comparator.new(unserialize(obj))
        end
      end

      def serialize(data)
        attribs = data.dup
        attribs['set_1']   = JSON.generate(attribs['set_1'])   if attribs['set_1']
        attribs['set_2']   = JSON.generate(attribs['set_2'])   if attribs['set_2']
        attribs['options'] = JSON.generate(attribs['options']) if attribs['options']
        attribs
      end

      def unserialize(obj)
        attribs = obj.to_h.rekey { |k| k.to_s }
        attribs['set_1']   = JSON.parse(attribs['set_1'])   if attribs['set_1']
        attribs['set_2']   = JSON.parse(attribs['set_2'])   if attribs['set_2']
        attribs['options'] = JSON.parse(attribs['options']) if attribs['options']
        attribs
      end
    end
  end
end
