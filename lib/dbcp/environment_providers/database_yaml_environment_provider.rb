require 'yaml'

module Dbcp
  class DatabaseYamlEnvironmentProvider
    def initialize(database_yaml_path)
      @database_yaml_path = database_yaml_path
    end

    # @return [Environment, nil]
    def find(environment_name)
      begin
        environment_hash = read_file[environment_name]
        if environment_hash
          build_environment environment_name, environment_hash
        else
          nil
        end
      rescue Errno::ENOENT
        return nil
      end
    end

   private

    def read_file
      YAML.load_file @database_yaml_path
    end

    def build_environment(environment_name, environment_hash)
      Environment.new({
        environment_name: environment_name,
        database:         Database.build(environment_hash)
      })
    end
  end
end
