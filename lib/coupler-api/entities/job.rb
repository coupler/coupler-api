module CouplerAPI
  Job = Entity([
    :id,
    :kind,
    :status,
    :error,
    :linkage_id,
    :started_at,
    :ended_at
  ])
end
