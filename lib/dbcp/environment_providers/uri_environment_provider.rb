require 'uri'

module Dbcp
  class UriEnvironmentProvider
    def find(environment_name)
      uri = URI.parse(environment_name)
      return nil unless uri.scheme

      build_environment environment_name, uri
    end

    private

    def build_environment(environment_name, uri)
      Environment.new({
        environment_name: environment_name,
        database:         Database.build({
          'adapter'  => uri.scheme,
          'username' => uri.user,
          'password' => uri.password,
          'host'     => uri.host,
          'port'     => uri.port,
          'database' => uri.path[1..-1] # Trim leading '/'
        }),
        execution_host:   LocalExecutionHost.new
      })
    end
  end
end
