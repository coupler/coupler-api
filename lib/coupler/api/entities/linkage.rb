module Coupler::API
  Linkage = Entity([
    :id,
    :name,
    :description,
    :threshold,
    :dataset_1_id,
    :dataset_2_id,
  ]) do
    attr_accessor :dataset_1, :dataset_2, :jobs, :comparators, :linkage_results

    def to_h
      result = super
      result['dataset_1'] = dataset_1.to_h(true) if dataset_1
      result['dataset_2'] = dataset_2.to_h(true) if dataset_2
      result['jobs'] = jobs.collect(&:to_h) if jobs
      result['comparators'] = comparators.collect(&:to_h) if comparators
      result['linkage_results'] = linkage_results.collect(&:to_h) if linkage_results
      result
    end
  end
end
