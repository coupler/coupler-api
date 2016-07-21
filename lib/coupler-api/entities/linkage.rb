module CouplerAPI
  Linkage = Entity([
    :id,
    :name,
    :description,
    :dataset_1_id,
    :dataset_2_id,
  ]) do
    attr_accessor :dataset_1, :dataset_2, :jobs, :comparators
  end
end
