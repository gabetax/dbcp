module Dbcp
  class Database
    class BlankDatabaseDefinition < StandardError; end
    class UnsupportedDatabaseAdapter < StandardError; end

    class << self
      def build(args)
        klass_for_adapter(args['adapter']).new args
      end

      def klass_for_adapter(adapter)
        klass = case adapter
        when /mysql/
          MysqlDatabase
        when /postgres/
          PostgresDatabase
        when nil, ''
          raise BlankDatabaseDefinition.new("No database adapter was provided.")
        else
          raise UnsupportedDatabaseAdapter.new("Unsupported database adapter: #{adapter}")
        end
      end
    end

    include Virtus.value_object
    values do
      attribute :adapter
      attribute :database
      attribute :host, String, default: 'localhost'
      attribute :port, Fixnum
      attribute :socket
      attribute :username
      attribute :password
    end
  end
end
