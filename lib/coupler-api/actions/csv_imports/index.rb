module CouplerAPI
  module CsvImports
    class Index
      def initialize(repo)
        @repo = repo
      end

      def self.dependencies
        ['CsvImportRepository']
      end

      def run
        @repo.find.collect(&:to_h)
      end
    end
  end
end
