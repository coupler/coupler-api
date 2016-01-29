module Coupler
  module API
    module DatasetParams
      class Base
        attr_reader :errors

        VALID_TYPES = ['csv', 'mysql']

        def initialize(data)
          if !data.is_a?(Hash)
            raise ArgumentError, "expected argument to be a Hash"
          end

          @name = data['name']
          @type = data['type']
          @host = data['host']
          @username = data['username']
          @password = data['password']
          @table = data['table']
          @csv = data['csv']

          @errors = []
        end

        def valid?
          @errors.clear

          if @name.nil? || @name.empty?
            @errors.push("name must be present")
          end

          if !VALID_TYPES.include?(@type)
            @errors.push("type must be one of the following: #{VALID_TYPES.inspect}")
          else
            case @type
            when 'mysql'
              if @host.nil? || @host.empty?
                @errors.push("host must be present")
              end

              if @username.nil? || @username.empty?
                @errors.push("username must be present")
              end

              if @table.nil? || @table.empty?
                @errors.push("table must be present")
              end

              if !@csv.nil? && !@csv.empty?
                @errors.push("csv must not be present")
              end
            when 'csv'
              if !@host.nil? && !@host.empty?
                @errors.push("host must not be present")
              end

              if !@username.nil? && !@username.empty?
                @errors.push("username must not be present")
              end

              if !@table.nil? && !@table.empty?
                @errors.push("table must not be present")
              end

              if @csv.nil? || @csv.empty?
                @errors.push("csv must be present")
              end
            end
          end

          @errors.empty?
        end

        def to_hash
          {
            :name => @name,
            :type => @type,
            :host => @host,
            :username => @username,
            :password => @password,
            :table => @table,
            :csv => @csv
          }
        end
      end
    end
  end
end
