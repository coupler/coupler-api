module Coupler::API
  Migration = Entity([
    :id,
    :description,
    :operations,
    :input_dataset_id,
    :output_dataset_id
  ]) do
    attr_accessor :input_dataset, :output_dataset

    def to_h
      result = super
      result['input_dataset'] = input_dataset.to_h if input_dataset
      result['output_dataset'] = output_dataset.to_h if output_dataset
      result
    end
  end
end
