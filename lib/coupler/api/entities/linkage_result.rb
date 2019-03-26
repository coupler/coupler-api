module Coupler::API
  LinkageResult = Entity([
    :id,
    :database_path,
    :job_id,
    :linkage_id,
    :match_count
  ]) do
    def uri
      if RUBY_PLATFORM == "java"
        "jdbc:sqlite:#{database_path}"
      else
        "sqlite://#{database_path}"
      end
    end

    def calculate_match_count!
      adapter do |adapter|
        self.match_count = adapter.count(:matches)
      end
    end

    def fetch_matches(limit = 100, offset = nil)
      result = nil
      adapter do |adapter|
        result = adapter.find(:matches, nil, limit, offset)
      end
      result
    end

    private

    def adapter
      adapter = SequelAdapter.new(uri)
      yield adapter
      adapter.close
    end
  end
end
