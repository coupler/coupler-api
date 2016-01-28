require 'sequel'

module Coupler
  module API
    class SequelAdapter
      def initialize(options)
        @options = options
      end

      def migrate(path)
        Sequel.extension(:migration)
        Sequel::Migrator.apply(db, path)
      end

      def find(name)
        db[name].all
      end

      def first(name, conditions)
        db[name].where(conditions).first
      end

      def create(name, data)
        db[name].insert(data)
      end

      def delete(name, conditions)
        ds = db[name].where(conditions)
        result = ds.all
        ds.delete
        result
      end

      private

      def db
        if @db.nil?
          @db = Sequel.connect(@options)
        end
        @db
      end
    end
  end
end
