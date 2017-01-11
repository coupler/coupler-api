require 'test_helper'

module CouplerAPI
  module UnitTests
    class SequelAdapterTest < Minitest::Test
      def setup
        @db = Minitest::Mock.new
        @relation = Minitest::Mock.new
        @options = { foo: 'bar' }
        @adapter = CouplerAPI::SequelAdapter.new(@options)
      end

      def test_find
        connect_args = nil
        connect = lambda { |*args| connect_args = args; @db }
        @db.expect(:[], @relation, [:foo])
        @relation.expect(:all, :return_value)
        Sequel.stub :connect, connect do
          assert_equal :return_value, @adapter.find(:foo)
        end

        assert_equal([@options], connect_args)
        @db.verify
        @relation.verify
      end

      def test_find_with_conditions
        @db.expect(:[], @relation, [:foo])
        @relation.expect(:where, @relation, ['condition'])
        @relation.expect(:all, :return_value)
        Sequel.stub :connect, @db do
          assert_equal :return_value, @adapter.find(:foo, 'condition')
        end
        @db.verify
        @relation.verify
      end

      def test_first
        @db.expect(:[], @relation, [:foo])
        @relation.expect(:where, @relation, ['condition'])
        @relation.expect(:first, :return_value)
        Sequel.stub :connect, @db do
          assert_equal :return_value, @adapter.first(:foo, 'condition')
        end
        @db.verify
        @relation.verify
      end

      def test_create
        @db.expect(:[], @relation, [:foo])
        @relation.expect(:insert, :return_value, ['data'])
        Sequel.stub :connect, @db do
          assert_equal :return_value, @adapter.create(:foo, 'data')
        end
        @db.verify
        @relation.verify
      end

      def test_update
        @db.expect(:[], @relation, [:foo])
        @relation.expect(:where, @relation, ['conditions'])
        @relation.expect(:update, :return_value, ['data'])
        Sequel.stub :connect, @db do
          assert_equal :return_value, @adapter.update(:foo, 'conditions', 'data')
        end
        @db.verify
        @relation.verify
      end

      def test_delete
        @db.expect(:[], @relation, [:foo])
        @relation.expect(:where, @relation, ['conditions'])
        @relation.expect(:all, :return_value)
        @relation.expect(:delete, 'junk')
        Sequel.stub :connect, @db do
          assert_equal :return_value, @adapter.delete(:foo, 'conditions')
        end
        @db.verify
        @relation.verify
      end

      def test_migrate
        extension_args = nil
        extension = lambda { |*args| extension_args = args; :return_value }
        apply_args = nil
        apply = lambda { |*args| apply_args = args; :return_value }
        Sequel.stub :connect, @db do
          Sequel.stub :extension, extension do
            Sequel::Migrator.stub :apply, apply do
              @adapter.migrate('foo')
            end
          end
        end
        assert_equal [:migration], extension_args
        assert_equal [@db, 'foo'], apply_args
      end
    end
  end
end
