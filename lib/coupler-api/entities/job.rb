module CouplerAPI
  Job = Entity([
    :id,
    :kind,
    :status,
    :error,
    :linkage_id,
    :linkage_result_id,
    :started_at,
    :ended_at
  ]) do
    attr_accessor :linkage_result

    def to_h
      result = super
      result['linkage_result'] = linkage_result.to_h if linkage_result
      result
    end
  end
end
