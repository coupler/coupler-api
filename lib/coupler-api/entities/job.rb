module CouplerAPI
  Job = Entity([
    :id,
    :kind,
    :status,
    :linkage_id,
    :started_at,
    :ended_at
  ])
end
