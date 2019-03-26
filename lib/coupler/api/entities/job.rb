module Coupler::API
  Job = Entity([
    :id,
    :kind,
    :status,
    :error,
    :linkage_id,
    :linkage_result_id,
    :migration_id,
    :started_at,
    :ended_at
  ]) do
    attr_accessor :linkage_result

    def to_h
      result = super
      if result[:started_at].is_a?(Time)
        result[:started_at] = result[:started_at].iso8601
      end
      if result[:ended_at].is_a?(Time)
        result[:ended_at] = result[:ended_at].iso8601
      end
      result[:linkage_result] = linkage_result.to_h if linkage_result
      result
    end
  end
end
