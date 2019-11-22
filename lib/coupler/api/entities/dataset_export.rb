module Coupler::API
  DatasetExport = Entity([
    :id,
    :dataset_id,
    :job_id,
    :kind,
    :path,
    :pending
  ])
end
