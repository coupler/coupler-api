require 'test_helper'

module CouplerAPI
  module UnitTests
    class LinkageCombinerTest < Minitest::Test
      def setup
        @linkage_repo        = Minitest::Mock.new
        @dataset_repo        = Minitest::Mock.new
        @comparator_repo     = Minitest::Mock.new
        @job_repo            = Minitest::Mock.new
        @linkage_result_repo = Minitest::Mock.new

        args = [
          @linkage_repo, @dataset_repo, @comparator_repo, @job_repo,
          @linkage_result_repo
        ]
        @combiner = LinkageCombiner.new(*args)
      end

      def test_find
        linkage = OpenStruct.new(:id => 123, :dataset_1_id => 1, :dataset_2_id => 2)
        @linkage_repo.expect(:first, linkage, [{ :id => 123 }])

        dataset_1 = {}
        dataset_2 = {}
        @dataset_repo.expect(:first, dataset_1, [{ :id => 1 }])
        @dataset_repo.expect(:first, dataset_2, [{ :id => 2 }])

        comparators = []
        @comparator_repo.expect(:find, comparators, [{ :linkage_id => 123 }])

        jobs = []
        @job_repo.expect(:find, jobs, [{ :linkage_id => 123 }])

        result = @combiner.find(:id => 123)
        assert_same(linkage, result)
        assert_same(dataset_1, linkage.dataset_1)
        assert_same(dataset_2, linkage.dataset_2)
        assert_same(comparators, linkage.comparators)
        assert_same(jobs, linkage.jobs)
      end
    end
  end
end
