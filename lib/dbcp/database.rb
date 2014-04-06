module Dbcp
  class Database
    class UnsupportedDatabaseAdapter < StandardError; end

    class << self
      def build(args)
        klass = case args[:adapter]
        when /postgres./
          PostgresDatabase
        else
          raise UnsupportedDatabaseAdapter.new("Unsupported database adapter: #{args[:adapter]}")
        end

        klass.new args
      end
    end

    include Virtus.value_object
    values do
      attribute :adapter
      attribute :database
      attribute :host, String, default: 'localhost'
      attribute :username
      attribute :password
    end
  end
end
