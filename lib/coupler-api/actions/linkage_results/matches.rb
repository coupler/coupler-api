module CouplerAPI
  module LinkageResults
    class Matches
      def initialize(repo, combiner, validator)
        @repo = repo
        @combiner = combiner
        @validator = validator
      end

      def self.dependencies
        ['LinkageResultRepository', 'LinkageCombiner',
         'LinkageResultValidators::Matches']
      end

      def run(params)
        errors = @validator.validate(params)
        if !errors.empty?
          return { 'errors' => errors }
        end

        linkage_result = @repo.first(:id => params[:id])
        if linkage_result.nil?
          return { 'errors' => ['linkage result not found'] }
        end

        linkage = @combiner.find({:id => linkage_result.linkage_id}, [:dataset_1, :dataset_2])
        if linkage.nil?
          return { 'errors' => ['linkage not found'] }
        end

        # get indicated match
        match = linkage_result.fetch_matches(1, params[:match_index]).first
        if match.nil?
          return { 'errors' => ['match not found'] }
        end

        fields_1 = linkage.dataset_1.fields
        primary_key_1 = fields_1.find { |f| f['primary_key'] }
        if primary_key_1.nil?
          raise "can't get primary key for dataset 1"
        end
        record_1 = linkage.dataset_1.fetch_records(primary_key_1['name'] => match[:id_1]).first
        if record_1.nil?
          raise "can't find record #{match.id_1} in dataset 1"
        end

        fields_2 = linkage.dataset_2.fields
        primary_key_2 = fields_2.find { |f| f['primary_key'] }
        if primary_key_2.nil?
          raise "can't get primary key for dataset 2"
        end
        record_2 = linkage.dataset_2.fetch_records(primary_key_2['name'] => match[:id_2]).first
        if record_2.nil?
          raise "can't find record #{match.id_2} in dataset 2"
        end

        { 'record_1' => record_1, 'record_2' => record_2, 'score' => match[:score] }
      end
    end
  end
end
