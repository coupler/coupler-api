Sequel.migration do
  up do
    alter_table(:jobs) do
      set_column_type(:started_at, String)
      set_column_type(:ended_at, String)
    end
    from(:jobs).each do |data|
      started_at = data[:started_at]
      if started_at.is_a?(String)
        started_at = Time.parse(started_at).iso8601
      end

      ended_at = data[:ended_at]
      if ended_at.is_a?(String)
        ended_at = Time.parse(ended_at).iso8601
      end
      from(:jobs).where(id: data[:id]).update({
        started_at: started_at,
        ended_at: ended_at
      })
    end

    alter_table(:csv_imports) do
      set_column_type(:created_at, String)
    end
    from(:csv_imports).each do |data|
      created_at = data[:created_at]
      if created_at.is_a?(String)
        created_at = Time.parse(created_at).iso8601
      end

      from(:csv_imports).where(id: data[:id]).update({
        created_at: created_at
      })
    end
  end
end
